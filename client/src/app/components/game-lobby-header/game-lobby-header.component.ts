import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { GameLobbyService } from '@app/services/game-services/game-lobby.service';
import { GameType } from '@common/enums/game-type';
import { TranslateService } from '@ngx-translate/core';

@Component({
	selector: 'app-game-lobby-header',
	templateUrl: './game-lobby-header.component.html',
	styleUrls: ['./game-lobby-header.component.scss']
})
export class GameLobbyHeaderComponent {
	get gameId(): number {
		return this.gameLobbyService.gameId;
	}

	get gameMode(): string {
		const type = this.gameInfoService.getGameType();
		if (type == GameType.EliminationGame)
			return this.translateService.instant('GameMode.Elimination');
		else if (type == GameType.SurvivalGame)
			return this.translateService.instant('GameMode.Survival');
		return this.translateService.instant('GameMode.Classical');
	}

	get quizInfo(): string {
		const quiz = this.gameInfoService.getQuiz();
		if (this.gameInfoService.getGameType() == GameType.EliminationGame)
			quiz.title = this.translateService.instant('RandomQuizHeaderComponent.RandomQuiz');
		return quiz.title + ' - ' + quiz.questions.length + ' questions';
	}

	constructor(
		private readonly gameLobbyService: GameLobbyService,
		private readonly gameInfoService: GameInfoService,
		private readonly translateService: TranslateService,
	) { }

	copyGameId() {
		navigator.clipboard.writeText(this.gameId.toString());
	}
}
