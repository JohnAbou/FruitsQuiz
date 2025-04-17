export interface Player {
    id: string;
    name: string;
    score?: number;
    bonusCount?: number;
    roundSurvived?: number;
    averageAnswerTime: number;

    emitToUser<ValuType>(eventName: string, eventValue?: ValuType): void;
    removeEventListeners(eventName: string): void;
    onUserEvent<EventType>(eventName: string, callback: (eventValue: EventType) => void): void;
}
