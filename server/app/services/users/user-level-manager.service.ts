import { Service } from "typedi";
import { DataManagerService } from "../data/data-manager.service";
import { USER_EXPERIENCE_COLLECTION } from "@app/consts/database.consts";
import { UserExperience, UserExperienceInfo } from "@common/interfaces/user-experience";
import { UsernameModificationService } from "./username-modification.service";

export interface ExperienceLoot {
    leveledUp: boolean;
    expGained: number;
    expEnd: number;
    expToNextLevel: number;
}

@Service()
export class UserLevelManager {
    constructor(
        private dataManager: DataManagerService<UserExperience>,
        private usernameModifiedService: UsernameModificationService,
    ) {
        this.dataManager.setCollection(USER_EXPERIENCE_COLLECTION);
        this.usernameModifiedService.usernameModifiedEvent
            .subscribe((event) => this.handleUsernameModified(event));
    }

    async addExperienceToUser(username: string, expValue: number): Promise<ExperienceLoot | undefined> {
        if (!username) return undefined;

        const experienceGained: ExperienceLoot = {
            leveledUp: false,
            expGained: 0,
            expEnd: 0,
            expToNextLevel: 0,
        };

        const currentExperience = await this.getUserExperience(username);
        experienceGained.expGained = expValue;
        currentExperience.experience += expValue;

        while (currentExperience.experience >= this.getExperienceForNextLevel(currentExperience.level)) {
            currentExperience.experience -= this.getExperienceForNextLevel(currentExperience.level);
            currentExperience.level++;
            experienceGained.leveledUp = true;
        }

        experienceGained.expEnd = currentExperience.experience;
        experienceGained.expToNextLevel = this.getExperienceForNextLevel(currentExperience.level);

        await this.dataManager.addElement(currentExperience);
        return experienceGained;
    }

    async getUserExperience(username: string): Promise<UserExperience> {
        let userExperience = await this.dataManager.getElementByUsername(username);
        userExperience ??= { id: '0', username, level: 1, experience: 0 };
        return userExperience;
    }

    async getUserExperienceInfo(username: string): Promise<UserExperienceInfo> {
        const userExperience = await this.getUserExperience(username);
        const expToNextLevel = this.getExperienceForNextLevel(userExperience.level);
        return { ...userExperience, expToNextLevel };
    }

    private getExperienceForNextLevel(level: number): number {
        return 100 * (level * Math.log2(level + 1));
    }

    private async handleUsernameModified(event: { newUsername: string; oldUsername: string; }) {
        await this.dataManager.updateElements({ username: event.oldUsername }, { username: event.newUsername });
    }
}