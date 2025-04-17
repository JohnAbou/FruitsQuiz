import { Injectable } from '@angular/core';
import { GameBaseService } from './base-classes/game-base.service';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { GameMessage } from '@app/interfaces/game-message';
import { MessageTranslationService } from '../message-translation.service';
import { GameInfoService } from './game-info.service';
import { GameType } from '@common/enums/game-type';

@Injectable({
    providedIn: 'root',
})
export class GameCorrectionService extends GameBaseService {
    constructor(
        socketFactory: SocketFactoryService,
        private dialogModalService: DialogModalService,
        private messageTranslationService: MessageTranslationService,
        private gameInfoService: GameInfoService,
    ) {
        super(socketFactory);
        this.setUpSocket();
    }

    private setUpSocket() {
        this.socketService.on(GameAnswerSocketEvent.SendCorrectionMessage, this.receiveCorrectionMessage.bind(this));
    }

    private receiveCorrectionMessage(correctionMessage: GameMessage) {
        if (this.gameInfoService.getGameType() != GameType.NormalGame) return;

        let message = this.messageTranslationService
            .getTranslateMessageWithValues(correctionMessage.code, correctionMessage.values);

        this.dialogModalService.openSnackBar(message);
    }
}
