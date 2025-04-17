import { DataManagerService } from "./data-manager.service";
import { Service } from "typedi";
import { USER_COLLECTION } from "@app/consts/database.consts";
import { DataBaseAcces } from "./database-acces.service";
import { User } from "@app/interfaces/users/user";
import { UsersStatsService } from "../users/user-stats-service";
import { Subject } from "rxjs";

const MAX_CURRENCY = 9999;

export interface CurrencyUpdateEvent {
    userId: string;
    newBalance: number;
}

@Service()
export class UserDataManager extends DataManagerService<User> {
    public currencyUpdateEvent = new Subject<CurrencyUpdateEvent>();

    constructor(
        dbAcces: DataBaseAcces,
        private userStatsService: UsersStatsService,
    ) {
        super(dbAcces);
        this.setCollection(USER_COLLECTION);
    }

    async getUserCurrency(userId: string): Promise<number> {
        const user = await this.getElementById(userId) as any;
        if (!user) return 0;

        return user.currency ?? 0;
    }

    async attemptToRemoveUserCurrency(userId: string, amount: number): Promise<boolean> {
        const user = await this.getElementById(userId) as any;
        if (!user) return false;

        if (user.currency - amount < 0) return false;
        await this.removeUserCurrency(userId, amount);
        return true;
    }

    async removeUserCurrency(userId: string, amount: number): Promise<number> {
        if (amount <= 0) throw new Error("Amount must be greater than 0");

        const collection = this.getCollection();
        const result = await collection.findOneAndUpdate({ id: userId }, { $inc: { currency: -amount } }, { returnDocument: 'after' });
        if (!result) return -1;

        this.userStatsService.incrementCoinSpent(userId, amount);
        const newBalance = result.currency ?? -1;
        this.currencyUpdateEvent.next({ userId, newBalance });
        return newBalance;
    }

    async addUserCurrency(userId: string, amount: number, shouldUpdateStats = true): Promise<number> {
        if (amount <= 0) throw new Error("Amount must be greater than 0");

        const collection = this.getCollection();
        const result = await collection.findOneAndUpdate(
            { id: userId },
            [
                {
                    $set: {
                        currency: {
                            $min: [
                                { $add: [{ $ifNull: ["$currency", 0] }, amount] },
                                MAX_CURRENCY
                            ]
                        }
                    }
                }
            ],
            { returnDocument: 'after' }
        );
        if (!result) return -1;

        const newBalance = result.currency ?? -1;
        this.currencyUpdateEvent.next({ userId, newBalance });
        if (shouldUpdateStats) this.userStatsService.incrementCoinGained(userId, amount);
        return newBalance;
    }

    async selectUserAvatar(username: string, avatarId: string): Promise<boolean> {
        return this.updateElement({ username }, { activeAvatarId: avatarId });
    }

    async addAndSelectAvatar(username: string, avatarId: string): Promise<boolean> {
        const user = await this.getElementByUsername(username);
        if (!user) return false;

        user.avatarIds.push(avatarId);
        return this.updateElement({ username }, { avatarIds: user.avatarIds, activeAvatarId: avatarId });
    }

    async updateUserTheme(userId: string, theme: string): Promise<boolean> {
        const result = await this.getCollection().updateOne({ id: userId }, { $set: { theme } });
        return result.acknowledged;
    }

    async updateUserBackground(userId: string, background: string): Promise<boolean> {
        const result = await this.getCollection().updateOne({ id: userId }, { $set: { background } });
        return result.acknowledged;
    }
}