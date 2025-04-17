import { Component } from '@angular/core';
import { GameResultsService } from '@app/services/game-services/game-results.service';
import { map } from 'rxjs';

@Component({
	selector: 'app-result-winner',
	templateUrl: './result-winner.component.html',
	styleUrls: ['./result-winner.component.scss']
})
export class ResultWinnerComponent {

	get winnerName() {
		return this.gameResultService.gameResult.pipe(map((result) => result.winner?.name));
	}

	get wasTie() {
		return this.gameResultService.gameResult.pipe(map((result) => result.wasTie));
	}

	constructor(private readonly gameResultService: GameResultsService) {}
}
