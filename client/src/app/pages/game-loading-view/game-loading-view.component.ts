import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';

@Component({
	selector: 'app-game-loading-view',
	templateUrl: './game-loading-view.component.html',
	styleUrls: ['./game-loading-view.component.scss']
})
export class GameLoadingViewComponent {
	constructor(private gameInfoService: GameInfoService) { }

	get quizTitle(): string {
		const playedQuiz = this.gameInfoService.getQuiz();
		return playedQuiz.title;
	}
}
