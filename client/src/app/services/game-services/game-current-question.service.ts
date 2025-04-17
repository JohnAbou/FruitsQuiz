import { Injectable } from '@angular/core';
import { QuestionWithIndex } from '@common/interfaces/question';
import { GameListenerService } from './base-classes/game-listener.service';
import { NULL_QUESTION } from '@app/consts/game.consts';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';
import { BehaviorSubject } from 'rxjs';
import { QuestionType } from '@common/enums/question-type';

@Injectable({
    providedIn: 'root',
})
export class GameCurrentQuestionService extends GameListenerService {
    private questionSubject = new BehaviorSubject<QuestionWithIndex>({ ...NULL_QUESTION, index: 0 });
    private canBuyHint: BehaviorSubject<boolean>;

    getCurrentQuestion(): QuestionWithIndex {
        return this.questionSubject.getValue();
    }

    getCurrentQuestionObservable() {
        return this.questionSubject.asObservable();
    }

    getCanBuyHint() {
        return this.canBuyHint.asObservable();
    }

    protected initializeState(): void {
        this.canBuyHint ??= new BehaviorSubject(false);
        this.canBuyHint.next(false);

        this.questionSubject ??= new BehaviorSubject<QuestionWithIndex>({ ...NULL_QUESTION, index: 0 });
        this.questionSubject.next({ ...NULL_QUESTION, index: 0 });
    }

    protected setUpSocket() {
        this.socketService.on(GamePlaySocketEvent.SendQuestionData, (question: QuestionWithIndex) => {
            this.questionSubject.next(question);

            const canBuyHint = this.getCurrentQuestion().type !== QuestionType.QCM ? false : this.getCurrentQuestion().choices.length > 2;
            this.canBuyHint.next(canBuyHint);
        });
    }
}
