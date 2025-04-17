import { Player } from '@common/interfaces/player';
import { Socket } from 'socket.io';

export class Client implements Player {
    id: string;
    name: string;
    score: number;
    bonusCount: number;
    roundSurvived: number;
    averageAnswerTime: number;

    constructor(private socket: Socket) {
        this.resetState();
    }

    emitToUser<ValuType>(eventName: string, eventValue?: ValuType) {
        this.socket.emit(eventName, eventValue);
    }

    onUserEvent<EventType, CallBackArgType>(
        eventName: string,
        callback: (eventValue?: EventType, callback?: (callbackArg: CallBackArgType) => void) => void,
    ) {
        this.socket.on(eventName, callback);
    }

    removeEventListeners(eventName: string) {
        this.socket.removeAllListeners(eventName);
    }

    resetState() {
        this.score = 0;
        this.bonusCount = 0;
        this.roundSurvived = 0;
        this.averageAnswerTime = 0;
    }
}
