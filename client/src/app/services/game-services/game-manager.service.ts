import { Injectable } from '@angular/core';
import { Question } from '@common/interfaces/question';
import { BehaviorSubject, Observable } from 'rxjs';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GameListenerService } from './base-classes/game-listener.service';
import { GameCurrentQuestionService } from './game-current-question.service';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';

@Injectable({
    providedIn: 'root',
})
export class GameManagerService extends GameListenerService {
    private hasSubmitedAnswer: boolean = false;

    private currentScoreSubject = new BehaviorSubject<number>(0);
    private isEliminatedSubject = new BehaviorSubject<boolean>(false);

    private hintReceivedSubject = new BehaviorSubject<number>(-1);
    private hintAvailableSubject = new BehaviorSubject<boolean>(true);
    private hintPriceSubject = new BehaviorSubject<number>(Number.MAX_SAFE_INTEGER);
    
    constructor(
        socketFactory: SocketFactoryService,
        private gameCurrentQuestionService: GameCurrentQuestionService,
    ) {
        super(socketFactory);
    }

    getCurrentQuestion(): Question {
        return this.gameCurrentQuestionService.getCurrentQuestion();
    }

    getHintReceivedObservable() {
        return this.hintReceivedSubject.asObservable();
    }

    getHintAvailableObservable() {
        return this.hintAvailableSubject.asObservable();
    }

    getHintPriceObservable() {
        return this.hintPriceSubject.asObservable();
    }

    getCurrentScoreObservable(): Observable<number> {
        return this.currentScoreSubject.asObservable();
    }

    getIsEliminatedObservable() {
        return this.isEliminatedSubject.asObservable();
    }

    canSubmitAnswer(): boolean {
        return !this.hasSubmitedAnswer;
    }

    updateHasSubmitedAnswer(hasSubmitedAnswer: boolean) {
        this.hasSubmitedAnswer = hasSubmitedAnswer;
    }

    submitAnswers() {
        this.hasSubmitedAnswer = true;
        this.socketService.emit(GameAnswerSocketEvent.SubmitAnswer);
        this.hintAvailableSubject.next(false);
    }

    buyHint() {
        this.socketService.emit(GameAnswerSocketEvent.BuyHint);
        this.hintAvailableSubject.next(false);
    }

    toggleAnswerChoice(index: number) {
        // Because of some error in the transfer when sending 0 when shift by one during the transfer
        this.socketService.emit(GameAnswerSocketEvent.ToggleAnswerChoices, index + 1);
    }

    updateNumericAnswer(value: number) {
        this.socketService.emit(GameAnswerSocketEvent.UpdateNumericAnswer, value);
    }

    updateAnswerResponse(updatedResponse: string) {
        this.socketService.emit(GameAnswerSocketEvent.UpdateAnswerResponse, updatedResponse);
    }

    protected setUpSocket() {
        this.socketService.on(GamePlaySocketEvent.SendQuestionData, () => this.updateHasSubmitedAnswer(false));

        this.socketService.on(GamePlayerSocketEvent.SendPlayerScore, (updatedScore: number) => {
            this.currentScoreSubject.next(updatedScore);
        });

        this.socketService.on(GamePlayerSocketEvent.EliminatePlayer, () => this.isEliminatedSubject.next(true));
        this.socketService.on(GameAnswerSocketEvent.SendCorrectAnswer, () => this.updateHasSubmitedAnswer(true));
        this.socketService.on(GameAnswerSocketEvent.SendHint, (index: number) => this.receiveHint(index-1));
        this.socketService.on(GamePlaySocketEvent.SendQuestionData, () => this.questionReset());
        this.socketService.on('gameHintCost', (price: number) => this.hintPriceSubject.next(price));
    }

    protected initializeState(): void {
        this.currentScoreSubject = new BehaviorSubject<number>(0);
        this.isEliminatedSubject = new BehaviorSubject<boolean>(false);
        this.hintReceivedSubject = new BehaviorSubject<number>(-1);
        this.hintAvailableSubject = new BehaviorSubject<boolean>(true);
        this.hintPriceSubject = new BehaviorSubject<number>(Number.MAX_SAFE_INTEGER);
    }

    private receiveHint(index: number) {
        this.hintReceivedSubject.next(index);
    }

    private questionReset() {
        this.hintReceivedSubject.next(-1);
        this.hintAvailableSubject.next(true);
    }
}
