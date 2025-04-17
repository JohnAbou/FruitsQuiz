import { Injectable } from '@angular/core';
import { GameListenerService } from './base-classes/game-listener.service';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';

@Injectable({
  providedIn: 'root',
})
export class GameCorrectedAnswerService extends GameListenerService {
  private correctAnswer: number[] = []; 
  private numericAnswer: number | null = null;
  private showCorrectAnswer: boolean = false;

  private valueBounds: number[] = [];

  shouldShowCorrectedAnswer(): boolean {
    return this.showCorrectAnswer;
  }

  isAnswerCorrected(answerIndex: number): boolean {
    return this.showCorrectAnswer && this.correctAnswer.includes(answerIndex);
  }

  

  getNumericAnswer(): number | null {
    return this.numericAnswer;
  }

  getValueBounds(): number[] {
    return this.valueBounds;
  }

  protected setUpSocket() {
    this.socketService.on(GamePlaySocketEvent.SendQuestionData, (question: any) => {
      this.handleQuestionData(question);
    });

    this.socketService.on(GameAnswerSocketEvent.SendCorrectAnswer, (data: number | number[]) => {
      this.correctAnswer = Array.isArray(data) ? data : [];
      this.numericAnswer = Array.isArray(data) ? null : data;
      this.showCorrectAnswer = true;
    });
  }

  private handleQuestionData(question: any) {
    this.initializeState();
    if (question.estimations) {
        this.valueBounds = [question.estimations.lowerBound, question.estimations.upperBound];
      }
  }

  protected initializeState(): void {
    this.showCorrectAnswer = false;
    this.correctAnswer = [];
    this.numericAnswer = null;
    this.valueBounds = []; // 
  }
}
