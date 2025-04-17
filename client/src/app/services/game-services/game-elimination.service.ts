import { Injectable } from '@angular/core';
import { GameListenerService } from './base-classes/game-listener.service';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { MatDialog } from '@angular/material/dialog';
import { EliminationModalComponent } from '@app/components/modal/elimination-modal/elimination-modal.component';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
    providedIn: 'root',
})
export class GameEliminationService extends GameListenerService {
    constructor(
        private readonly dialog: MatDialog,
        private readonly translateService: TranslateService,
        socketFactoryService: SocketFactoryService,
    ) {
        super(socketFactoryService);
    }

    protected setUpSocket() {
        this.socketService.on(GamePlayerSocketEvent.EliminatePlayer, this.onElimination.bind(this));
    }

    protected initializeState() { }

    private onElimination(reason: number) {
        if (!reason) return;
        
        let reasonString = "";
        switch (reason) {
            case 1:
                reasonString = "GameEliminationService.WrongAnswer";
                break;
            case 2:
                reasonString = "GameEliminationService.LastAnswer";
                break;
            case 3:
                reasonString = "GameEliminationService.NoAnswer";
        }

        let translatedReasonString = this.translateService.instant(reasonString);
        this.dialog.open(EliminationModalComponent, {
            data: translatedReasonString, autoFocus: true,
            disableClose: true, hasBackdrop: true
        });
    }
}
