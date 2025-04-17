import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { GameSurvivalService } from '@app/services/game-services/game-survival.service';

@Component({
	selector: 'app-survival-result-view',
	templateUrl: './survival-result-view.component.html',
	styleUrls: ['./survival-result-view.component.scss']
})
export class SurvivalResultViewComponent {

	get questionSurvived() {
		return this.gameSurvivalService.questionSurvived;
	}

	get questions() {
		return this.gameInfoService.getQuiz().questions;
	}

	get hasWonGame() {
        return this.gameSurvivalService.questionSurvived === this.questions.length;
    }

	constructor(
		private readonly gameSurvivalService: GameSurvivalService,
		private readonly gameInfoService: GameInfoService,
	) {}
}
