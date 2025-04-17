import { BotAvatarType, BotDifficulty } from '@common/interfaces/bot-player';
import { Player } from '../interfaces/users/player';
import { randomUUID } from 'crypto';

export class BotPlayer implements Player {
    id: string;
    name: string;
    score: number;
    bonusCount: number;
    roundSurvived: number;
    averageAnswerTime: number;
    difficulty: BotDifficulty;
    avatarType: BotAvatarType;

    constructor() {
        this.id = randomUUID();
        this.name = `Bot-${Math.random().toString(36).substring(7)}`;
        this.score = 0;
        this.bonusCount = 0;
        this.roundSurvived = 0;
        this.difficulty = BotDifficulty.Intermediate;
        this.avatarType = this.getRandomAvatarType();
    }

    emitToUser<ValuType>(eventName: string, eventValue?: ValuType): void {}

    onUserEvent<EventType, CallBackArgType>(
        eventName: string,
        callback: (eventValue?: EventType, callback?: (callbackArg: CallBackArgType) => void) => void,
    ): void {}

    removeEventListeners(eventName: string): void {}

    resetState(): void {
        this.score = 0;
        this.bonusCount = 0;
        this.roundSurvived = 0;
    }

    private getRandomAvatarType(): BotAvatarType {
        const types = Object.values(BotAvatarType);
        const randomIndex = Math.floor(Math.random() * types.length);
        return types[randomIndex];
    }
}
