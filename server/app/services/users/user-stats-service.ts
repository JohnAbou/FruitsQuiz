import { Service } from 'typedi';
import { DataManagerService } from '../data/data-manager.service';
import { DataBaseAcces } from '../data/database-acces.service';
import { USER_COLLECTION, USER_STAT_COLLECTION } from '@app/consts/database.consts';
import { UserStats } from '@app/interfaces/user-stats';

@Service({ transient: true })
export class UsersStatsService extends DataManagerService<UserStats> {

    get collection() {
        return this.getCollection();
    }

    constructor(dbAcces: DataBaseAcces) {
        super(dbAcces);
        this.setCollection(USER_STAT_COLLECTION);
    }

    async initializeUserStats(userId: string) {
        await this.collection.insertOne(this.getDefault(userId));
    }

    async getUserStats(userId: string) {
        const current = await this.getElementById(userId);
        return current ?? this.getDefault(userId);
    }

    async getUsersStats() {
        return this.getCollection(USER_COLLECTION).aggregate([
            {
                $lookup: {
                    from: "userstats",
                    localField: "id",
                    foreignField: "id",
                    as: "userStats"
                }
            },
            {
                $unwind: {
                    path: "$userStats",
                    preserveNullAndEmptyArrays: true
                }
            },
            {
                $project: {
                    hashedPassword: 0,
                    _id: 0,
                    avatarIds: 0,
                    chatIds: 0,
                    email: 0,
                    "userStats._id": 0,
                }
            }
        ]).toArray();
    }

    async updateBestSurvivalScore(userId: string, score: number) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $max: { bestSurvivalScore: score } },
            { returnDocument: 'after' }
        ) as unknown as UserStats;
    }

    async incrementChallengeCompleted(userId: string) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { challengeCompleted: 1 } }
        ) as unknown as UserStats;
    }
    
    async incrementGameTime(userId: string, timeSeconds: number) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { totalGameTime: timeSeconds } }
        ) as unknown as UserStats;
    }

    async incrementGamePlayed(userId: string) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { totalGamePlayed: 1 } }
        ) as unknown as UserStats;
    }

    async incrementFailedQuestion(userId: string) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { totalQuestionAnswered: 1 } }
        ) as unknown as UserStats;
    }

    async incrementGottenQuestion(userId: string) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { totalQuestionGotten: 1, totalQuestionAnswered: 1 } }
        ) as unknown as UserStats;
    }

    async incrementCoinSpent(userId: string, amount: number) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { coinSpent: amount } }
        ) as unknown as UserStats;
    }

    async incrementCoinGained(userId: string, amount: number) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            { $inc: { coinGained: amount } }
        ) as unknown as UserStats;
    }

    async updateGameStats(userId: string, survivedQuestions: number, points: number) {
        return await this.collection.findOneAndUpdate(
            { id: userId },
            {
                $inc: {
                    totalPoints: points,
                    totalSurvivedQuestion: survivedQuestions
                },
            },
            { returnDocument: 'after' }
        ) as unknown as UserStats;
    }

    async updateGameResults(userId: string, wonGame: boolean, survivedQuestions: number, points: number) {
        const updateOperation = wonGame
            ? [
                {
                    $set: {
                        currentWinStreak: { $add: ["$currentWinStreak", 1] },
                        totalGameWon: { $add: ["$totalGameWon", 1] },
                        totalPoints: { $add: ["$totalPoints", points] },
                        totalSurvivedQuestion: { $add: ["$totalSurvivedQuestion", survivedQuestions] }
                    }
                },
                {
                    $set: {
                        bestWinStreak: { $max: ["$bestWinStreak", "$currentWinStreak"] }
                    }
                }
            ]
            : {
                $inc: {
                    totalPoints: points,
                    totalSurvivedQuestion: survivedQuestions
                },
                $set: { currentWinStreak: 0 }
            }

        return await this.collection.findOneAndUpdate(
            { id: userId },
            updateOperation,
            { returnDocument: 'before' }
        ) as unknown as UserStats;
    }

    private getDefault(userId: string): UserStats {
        return {
            id: userId, totalPoints: 0, totalSurvivedQuestion: 0, totalGameTime: 0,
            currentWinStreak: 0, bestWinStreak: 0, coinSpent: 0, totalGameWon: 0,
            challengeCompleted: 0, bestSurvivalScore: 0, coinGained: 0,
        }
    }
}
