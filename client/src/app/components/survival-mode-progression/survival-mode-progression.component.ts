import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { GameSurvivalService } from '@app/services/game-services/game-survival.service';

@Component({
	selector: 'app-survival-mode-progression',
	templateUrl: './survival-mode-progression.component.html',
	styleUrls: ['./survival-mode-progression.component.scss']
})
export class SurvivalModeProgressionComponent {

	get questionCount() {
		return this.gameInfoService.getQuiz().questions.length;
	}

	get questionSurvived() {
		return this.gameSurvivalService.questionSurvivedObservable;
	}

	constructor(
		private readonly gameInfoService: GameInfoService,
		private readonly gameSurvivalService: GameSurvivalService,
	) { }
}
