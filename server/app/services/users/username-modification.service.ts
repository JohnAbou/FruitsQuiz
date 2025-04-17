import { Service } from "typedi";
import { UserDataManager } from "../data/user-data-manager.service";
import { UsernameModifiedSocket } from "../sockets/username-modified-socket.service";
import { UsernameModifiedEvent } from "@app/interfaces/users/username-modified-event";
import { Subject } from "rxjs";
import { AvatarModifiedEvent } from "@app/interfaces/users/avatar-modified-event";

@Service()
export class UsernameModificationService {

    usernameModifiedEvent: Subject<UsernameModifiedEvent> = new Subject();

    constructor(
        private readonly userDataManager: UserDataManager,
        private readonly socketService: UsernameModifiedSocket,
    ) { }

    public async changeUsername(oldUsername: string, newUsername: string): Promise<boolean> {
        const user = await this.userDataManager.getElementByUsername(oldUsername);

        user.username = newUsername;
        const result = await this.userDataManager.replaceElement(user);

        if (result) this.triggerUsernameModifiedEvent({
            newUsername: newUsername,
            oldUsername: oldUsername,
        });
        return result;
    }

    public async selectAvatar(userId: string, username: string, newAvatar: string): Promise<boolean> {
        const result = await this.userDataManager.selectUserAvatar(username, newAvatar);
        if (result) this.triggerAvatarModifiedEvent({ username, newAvatar, userId });
        return result;
    }

    public async addAndSelectAvatar(userId: string, username: string, newAvatar: string): Promise<boolean> {
        const result = await this.userDataManager.addAndSelectAvatar(username, newAvatar);
        if (result) this.triggerAvatarModifiedEvent({ username, newAvatar, userId });
        return result;
    }

    private triggerAvatarModifiedEvent(event: AvatarModifiedEvent) {
        this.socketService.emitAvatarChangedNotification(event);
    }

    private triggerUsernameModifiedEvent(event: UsernameModifiedEvent) {
        this.usernameModifiedEvent.next(event);
        this.socketService.emitUsernameChangedNotification(event);
    }
}