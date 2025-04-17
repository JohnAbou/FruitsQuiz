import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ConfirmationModalComponent } from '@app/components/modal/confirmation-modal/confirmation-modal.component';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { GameJoiningService } from '@app/services/game-services/game-joining.service';
import { MessageTranslationService } from '@app/services/message-translation.service';
import { GameType } from '@common/enums/game-type';
import { GameInfo } from '@common/interfaces/game-info';
import { TranslateService } from '@ngx-translate/core';
import { MatDialog } from '@angular/material/dialog';

@Component({
    selector: 'app-game-joining-page',
    templateUrl: './game-joining-page.component.html',
    styleUrls: ['./game-joining-page.component.scss'],
})
export class GameJoiningPageComponent {
    constructor(
        private router: Router,
        private dialog: DialogModalService,
        private matDialog: MatDialog,
        public gameJoiningService: GameJoiningService,
        private message: MessageTranslationService,
        private translate: TranslateService,
    ) { }

    get games() {
        return this.gameJoiningService.filteredGamesInfo.asObservable();
    }

    getGameTitle(game: GameInfo) {
        const title = game.quizToPlay.title;
        return title === "system-special-quiz" ? this.translate.instant("GameJoiningHeader.RandomQuizTitle") : title;
    }

    getGameType(game: GameInfo): string {
        switch (game.gameType) {
            case GameType.NormalGame:
                return this.translate.instant("GameMode.Classical");
            case GameType.EliminationGame:
                return this.translate.instant("GameMode.Elimination");
            default:
                return this.translate.instant("GameMode.Survival");
        }
    }

    goToCreateGame() {
        this.router.navigate(['game-creation']);
    }

    async joinGame(game: GameInfo) {
        if (!game.entryFee) return this.joinGameIntern(game);

        const dialogRef = this.matDialog.open(ConfirmationModalComponent, {
            data: this.translate.instant('GameJoining.PayToJoin', { amount: game.entryFee })
        });

        dialogRef.afterClosed().subscribe(result => { if (result) this.joinGameIntern(game); });
    }

    private async joinGameIntern(game: GameInfo) {
        const response = await this.gameJoiningService.joinGame(game);
        if (response.success) this.router.navigate(['game-view']);
        else this.dialog.openSnackBar(this.message.getTranslatedMessage(response.code!));
    }
}
