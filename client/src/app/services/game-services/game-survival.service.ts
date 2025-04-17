import { Injectable } from '@angular/core';
import { GameListenerService } from './base-classes/game-listener.service';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { BehaviorSubject } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class GameSurvivalService extends GameListenerService {

    private readonly questionSurvivedSubject = new BehaviorSubject<number>(0);
    private readonly bestQuestionSurvivedSubject = new BehaviorSubject<number>(0);


    get questionSurvived() {
        return this.questionSurvivedSubject.value;
    }

    get survivalResult() {
        return this.bestQuestionSurvivedSubject.value;
    }

    get questionSurvivedObservable() {
        return this.questionSurvivedSubject.asObservable();
    }

    get survivalResultObservable() {
        return this.bestQuestionSurvivedSubject.asObservable();
    }

    constructor(
        socketFactoryService: SocketFactoryService,
    ) {
        super(socketFactoryService);
    }

    protected setUpSocket() {
        this.socketService.on(GamePlayerSocketEvent.SurvivedRound, this.onSurviedRoundEvent.bind(this));
        this.socketService.on(GamePlayerSocketEvent.SurvivalResult, this.onSurvivalResultEvent.bind(this));
    }

    protected initializeState() {
        this.questionSurvivedSubject?.next(0);
        this.bestQuestionSurvivedSubject?.next(0);
    }

    private onSurviedRoundEvent(survived: boolean) {
        if (survived)
            return this.questionSurvivedSubject.next(this.questionSurvivedSubject.value + 1);
    }

    private onSurvivalResultEvent(survivalResult: number) {
        this.bestQuestionSurvivedSubject.next(survivalResult);
    }
}
