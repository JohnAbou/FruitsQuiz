import { Component } from '@angular/core';
import { GameCurrentQuestionService } from '@app/services/game-services/game-current-question.service';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { QuestionWithIndex } from '@common/interfaces/question';

@Component({
	selector: 'app-game-question-info-header',
	templateUrl: './game-question-info-header.component.html',
	styleUrls: ['./game-question-info-header.component.scss']
})
export class GameQuestionInfoHeaderComponent {
	constructor(
		private currentQuestionService: GameCurrentQuestionService,
		private gameInfo: GameInfoService,
	) { }

	get numberQuestions(): number {
		return this.gameInfo.getQuiz().questions.length;
	}

	get question(): QuestionWithIndex {
		return this.currentQuestionService.getCurrentQuestion();
	}
}
