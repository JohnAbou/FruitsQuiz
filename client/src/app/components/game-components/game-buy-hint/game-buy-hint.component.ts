import { Component } from '@angular/core';
import { CurrencyService } from '@app/services/currency.service';
import { GameCurrentQuestionService } from '@app/services/game-services/game-current-question.service';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { combineLatest, map } from 'rxjs';

@Component({
	selector: 'app-game-buy-hint',
	templateUrl: './game-buy-hint.component.html',
	styleUrls: ['./game-buy-hint.component.scss']
})
export class GameBuyHintComponent {

	get canBuyHint() {
		return this.gameCurrentQuestionService.getCanBuyHint();
	}

	get hintPrice() {
		return this.gameManagerService.getHintPriceObservable();
	}

	get hintAvailable() {
		return combineLatest([
			this.gameManagerService.getHintAvailableObservable(),
			this.hintPrice,
			this.currencyService.currencyObservable
		]).pipe(
			map(([hintAvailable, hintPrice, currency]) => hintAvailable && hintPrice <= currency)
		);
	}

	constructor(
		private readonly gameManagerService: GameManagerService,
		private readonly gameCurrentQuestionService: GameCurrentQuestionService,
		private readonly currencyService: CurrencyService,
	) { }

	buyHint() {
		this.gameManagerService.buyHint();
	}
}
