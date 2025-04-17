import { Injectable } from '@angular/core';
import { NULL_QUIZ } from '@app/consts/game.consts';
import { GameInfo } from '@common/interfaces/game-info';
import { Quiz } from '@common/interfaces/quiz';
import { BehaviorSubject } from 'rxjs';
import { GameListenerService } from './base-classes/game-listener.service';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';
import { GameType } from '@common/enums/game-type';
import { ChatsService } from '@app/services/chat-services/chats-service';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';

@Injectable({
    providedIn: 'root',
})
export class GameInfoService extends GameListenerService {
    private gameIdSubject: BehaviorSubject<number>;
    private quizSubject: BehaviorSubject<Quiz>;
    private gameTypeSubject: BehaviorSubject<GameType>;

    constructor(
        private chatsService: ChatsService,
        socketFactoryService: SocketFactoryService,
    ) {
        super(socketFactoryService);

    }

    getGameId() {
        return this.gameIdSubject.value;
    }

    getGameIdObservable() {
        return this.gameIdSubject.asObservable();
    }

    getQuizObservable() {
        return this.quizSubject.asObservable();
    }

    getQuiz() {
        return this.quizSubject.value;
    }

    shouldRateQuiz() {
        return this.quizSubject.value.owner !== 'system';
    }

    getGameType() {
        return this.gameTypeSubject.value;
    }

    protected setUpSocket() {
        this.socketService.on(GamePlaySocketEvent.SendGameInfo, (gameInfo: GameInfo) => {
            this.updateGameInfo(gameInfo);
            if (gameInfo.gameType != GameType.SurvivalGame)
                this.chatsService.joinGameChat(gameInfo.gameId);
        });

    }

    protected initializeState() {
        this.gameTypeSubject ??= new BehaviorSubject<GameType>(GameType.LobbyGame);
        this.gameTypeSubject.next(GameType.LobbyGame);

        this.gameIdSubject ??= new BehaviorSubject<number>(0);
        this.gameIdSubject.next(0);

        this.quizSubject ??= new BehaviorSubject(NULL_QUIZ);
        this.quizSubject.next(NULL_QUIZ);
    }

    private updateGameInfo(gameInfo: GameInfo) {
        this.gameIdSubject.next(gameInfo.gameId);
        this.quizSubject.next(gameInfo.quizToPlay);
        this.gameTypeSubject.next(gameInfo.gameType);
    }
}
