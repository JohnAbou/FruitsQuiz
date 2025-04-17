export enum WinStreakState {
    Lost = 1,
    Improved = 2,
    Best = 3,
}

export interface WinStreakUpdate {
    wsState: WinStreakState,
    current: number,
    winCount: number,
}