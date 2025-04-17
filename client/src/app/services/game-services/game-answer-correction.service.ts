import { EventEmitter, Injectable } from '@angular/core';
import { GameListenerService } from './base-classes/game-listener.service';
import { AnswerToCorrect } from '@common/interfaces/answers/answer-to-correct';
import { VOID_ANSWER_TO_CORRECT } from '@app/consts/question.consts';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { BehaviorSubject } from 'rxjs';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';

@Injectable({
    providedIn: 'root',
})
export class GameAnswerCorrectionService extends GameListenerService {
    answerToCorrectUpdated: EventEmitter<void>;

    private correctingStateSubject: BehaviorSubject<number>;

    private answerToCorrect: AnswerToCorrect[];
    private currentAnswerIndex: number;

    getAnswer() {
        return this.currentAnswerIndex < this.answerToCorrect.length ? this.answerToCorrect[this.currentAnswerIndex] : VOID_ANSWER_TO_CORRECT;
    }

    scoreAnswer(score: number) {
        this.getAnswer().score = score;
        this.nextAnswer();
        this.answerToCorrectUpdated.emit();
    }

    getIsCorrectingObservable() {
        return this.correctingStateSubject.asObservable();
    }

    protected setUpSocket() {
        this.socketService.on(GameAnswerSocketEvent.SendAnswerToCorrect, (answersToCorrect: AnswerToCorrect[]) =>
            this.updateAnswerToCorrect(answersToCorrect),
        );

        this.socketService.on(GamePlaySocketEvent.SendQuestionData, () => this.correctingStateSubject.next(1));
        this.socketService.on(GameAnswerSocketEvent.QrlCorrectionStarted, () => this.correctingStateSubject.next(2));
        this.socketService.on(GameAnswerSocketEvent.QrlCorrectionFinished, () => this.correctingStateSubject.next(3));
    }

    protected initializeState(): void {
        this.answerToCorrectUpdated = new EventEmitter();
        this.correctingStateSubject = new BehaviorSubject(1);
        this.updateAnswerToCorrect([]);
    }

    private nextAnswer() {
        ++this.currentAnswerIndex;
        if (this.currentAnswerIndex !== this.answerToCorrect.length) return;

        this.socketService.emit(GameAnswerSocketEvent.SendAnswersCorrected, JSON.stringify(this.answerToCorrect));
    }

    private updateAnswerToCorrect(answersToCorrect: AnswerToCorrect[]) {
        this.answerToCorrect = answersToCorrect;
        this.currentAnswerIndex = 0;
        this.answerToCorrectUpdated.emit();
    }
}
