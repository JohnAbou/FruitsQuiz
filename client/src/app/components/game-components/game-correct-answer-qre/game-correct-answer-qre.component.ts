import { Component, Input } from '@angular/core';
import { Question } from '@common/interfaces/question';

@Component({
  selector: 'app-game-correct-answer-qre',
  templateUrl: './game-correct-answer-qre.component.html',
  styleUrls: ['./game-correct-answer-qre.component.scss']
})
export class GameCorrectAnswerQreComponent {
  @Input() question!: Question;
}
