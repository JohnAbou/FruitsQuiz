import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { GameType } from '@common/enums/game-type';

@Component({
	selector: 'app-game-score',
	templateUrl: './game-score.component.html',
	styleUrls: ['./game-score.component.scss']
})
export class GameScoreComponent {
	get isEliminatedObserver() {
		return this.gameManager.getIsEliminatedObservable();
	}

	get currentScoreObserver() {
		return this.gameManager.getCurrentScoreObservable();
	}

	get isClassicalGame() {
		return this.gameInfo.getGameType() == GameType.NormalGame;
	}

	constructor(
		private readonly gameManager: GameManagerService,
		private readonly gameInfo: GameInfoService,
	) {}

}
