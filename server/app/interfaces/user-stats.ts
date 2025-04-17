export interface UserStats {
    id: string;
    totalPoints: number;
    totalSurvivedQuestion: number;
    totalGameTime: number;
    totalGameWon: number;
    currentWinStreak: number;
    bestWinStreak: number;
    coinSpent: number;
    coinGained: number;
    challengeCompleted: number;
    bestSurvivalScore: number;
}