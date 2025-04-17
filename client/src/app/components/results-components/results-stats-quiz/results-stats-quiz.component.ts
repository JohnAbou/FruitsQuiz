import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';

@Component({
	selector: 'app-results-stats-quiz',
	templateUrl: './results-stats-quiz.component.html',
	styleUrls: ['./results-stats-quiz.component.scss']
})
export class ResultsStatsQuizComponent {
	get shouldRateQuiz() {
		return this.gameInfoService.shouldRateQuiz();
	}

	get quizTitle() {
		return this.gameInfoService.getQuiz().title;
	}

	get quizId() {
		return this.gameInfoService.getQuiz().id;
	}

	get quizOwner() {
		return this.gameInfoService.getQuiz().owner;
	}

	constructor(private gameInfoService: GameInfoService) { }
}
