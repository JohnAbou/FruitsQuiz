import { Player } from '@common/interfaces/player';
export class MockClient implements Player {
    id: string;
    name: string;
    score: number;
    bonusCount: number;
    roundSurvived: number;
    averageAnswerTime: number;

    emitToUser<ValuType>(eventName: string, eventValue?: ValuType) { }

    onUserEvent<EventType, CallBackArgType>(
        eventName: string,
        callback: (eventValue?: EventType, callback?: (callbackArg: CallBackArgType) => void) => void,
    ) { }

    removeEventListeners(eventName: string) { }

    resetState() {
        this.score = 0;
        this.bonusCount = 0;
        this.roundSurvived = 0;
        this.averageAnswerTime = 0;
    }
}
