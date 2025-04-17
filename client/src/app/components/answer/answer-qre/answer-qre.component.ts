import { Component, Input, OnInit } from '@angular/core';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { GameCorrectedAnswerService } from '@app/services/game-services/game-corrected-answer.service';

@Component({
  selector: 'app-answer-qre',
  templateUrl: './answer-qre.component.html',
  styleUrls: ['./answer-qre.component.scss']
})
export class AnswerQreComponent implements OnInit {
  @Input() isInteractive = false;
  currentValue: number = 0;

  constructor(
      private readonly gameManager: GameManagerService,
      public readonly gameCorrectedAnswerService: GameCorrectedAnswerService,
  ) {}

  ngOnInit(): void {
    const bounds = this.getValueBounds();
    this.currentValue = Math.round((bounds[0] + bounds[1]) / 2);
    this.onValueModified(this.currentValue.toString());

    if (this.gameCorrectedAnswerService.shouldShowCorrectedAnswer()) {
        const correctAnswer = this.gameCorrectedAnswerService.getNumericAnswer();
        if (correctAnswer !== null) {
            this.currentValue = correctAnswer;
        }
    }
  }

  canSubmitAnswer(): boolean {
    return this.isInteractive && this.gameManager.canSubmitAnswer();
  }

  onValueModified(value: string): void {
    const numericValue = Number(value);
    const [min, max] = this.getValueBounds();
    const middleValue = min + (max - min) / 2;
  
    if (this.gameCorrectedAnswerService.shouldShowCorrectedAnswer()) {
      const correctedAnswer = this.gameCorrectedAnswerService.getNumericAnswer();
      this.currentValue = correctedAnswer ?? middleValue;
    } else if (isNaN(numericValue)) {
      this.currentValue = middleValue;
    } else {
      this.currentValue = numericValue;
    }
    
    this.gameManager.updateNumericAnswer(this.currentValue);
  }

  onSliderChange(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.onValueModified(value);
  }
  
  onDirectInputChange(value: string): void {
    this.onValueModified(value);
  }

  getValueBounds(): number[] {
    return this.gameCorrectedAnswerService.getValueBounds();
  }

  isCurrentAnswerCorrect(): boolean {
    const correctAnswer = this.gameCorrectedAnswerService.getNumericAnswer();
    return this.gameCorrectedAnswerService.shouldShowCorrectedAnswer() && 
           correctAnswer === this.currentValue;
  }
}
