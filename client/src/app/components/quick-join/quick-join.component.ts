import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { GameJoiningService } from '@app/services/game-services/game-joining.service';
import { MessageTranslationService } from '@app/services/message-translation.service';
import { ConfirmationModalComponent } from '../modal/confirmation-modal/confirmation-modal.component';
import { MatDialog } from '@angular/material/dialog';
import { GameInfo } from '@common/interfaces/game-info';
import { TranslateService } from '@ngx-translate/core';

@Component({
	selector: 'app-quick-join',
	templateUrl: './quick-join.component.html',
	styleUrls: ['./quick-join.component.scss']
})
export class QuickJoinComponent {
	code = "";

	constructor(
		private router: Router,
		private dialog: DialogModalService,
		private matDialog: MatDialog,
		private gameJoiningService: GameJoiningService,
		private translate: MessageTranslationService,
		private translateService: TranslateService,
	) { }

	async joinGame() {
		const gameId = parseInt(this.code);
		if (!gameId || gameId < 1000 || gameId > 9999)
			return this.dialog.openSnackBar(this.translate.getTranslatedMessage(10001));

		const game = await this.gameJoiningService.findGameById(gameId);
		if (!game) return this.dialog.openSnackBar(this.translate.getTranslatedMessage(10000));

		if (!game.entryFee) return this.joinGameIntern(game);

		const dialogRef = this.matDialog.open(ConfirmationModalComponent, {
			data: this.translateService.instant('GameJoining.PayToJoin', { amount: game.entryFee })
		});

		dialogRef.afterClosed().subscribe(result => { if (result) this.joinGameIntern(game); });
	}

	private async joinGameIntern(game: GameInfo) {
		const response = await this.gameJoiningService.joinGame(game);

		if (response.success) this.router.navigate(['game-view']);
		else this.dialog.openSnackBar(this.translate.getTranslatedMessage(response.code!));
	}
}
