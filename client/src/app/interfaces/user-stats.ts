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
    totalGamePlayed: number;
    totalQuestionAnswered: number;
    totalQuestionGotten: number;
}

export interface UserWithStats {
    id: string;
    username: string;
    activeAvatarId: string;
    userStats: UserStats;
}