import { Component, Input } from '@angular/core';
import { GameChallengeService } from '@app/services/game-services/game-challenge.service';
import { GameLootService } from '@app/services/game-services/game-loot.service';
import { combineLatest, map } from 'rxjs';

@Component({
	selector: 'app-game-loots',
	templateUrl: './game-loots.component.html',
	styleUrls: ['./game-loots.component.scss']
})
export class GameLootsComponent {

	@Input() showCoinsPaid = true;

	get coinLoot() {
		return this.gameLootService.coinLoot;
	}

	get accomplishmentLoot() {
		return combineLatest([
			this.gameChallengeService.challengeObservable,
			this.gameChallengeService.challengeResultObservable
		]).pipe(
			map(([challenge, result]) =>  result?.success ? challenge.price : 0)
		);
	}

	get experienceLoot() {
		return this.gameLootService.experienceLoot;
	}

	constructor(
		private readonly gameLootService: GameLootService,
		private readonly gameChallengeService: GameChallengeService,
	) {}

	floor(value: number) {
		return Math.floor(value);
	}
}
