import { Player } from '@app/interfaces/users/player';
import { GameSessionBase } from './game-session-base';
import { GameConfig } from '@app/interfaces/game-config';
import { GameQuizHandlerService } from '@app/services/game/game-quiz-handler.service';
import { TimerService } from '@app/services/timer.service';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';
import { UserGameRole } from '@common/enums/user-game-role';
import { MockClient } from '../mock-client';
import { GameInfo } from '@common/interfaces/game-info';
import { GameType } from '@common/enums/game-type';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { UsersStatsService } from '@app/services/users/user-stats-service';
import Container from 'typedi';
import { GameEntryFeeService } from '@app/services/game/game-entry-fee.service';
import { UserDataManager } from '@app/services/data/user-data-manager.service';

export class GameSessionSurvival extends GameSessionBase {
    private roundSurvived = 0;
    private isAlive = true;

    get users() {
        return this.players;
    }

    get player() {
        return this.players.length > 0 ? this.players[0] : undefined;
    }

    constructor(timerService: TimerService, quizHandler: GameQuizHandlerService, gameConfig: GameConfig) {
        super(timerService, quizHandler, new GameEntryFeeService(0, Container.get(UserDataManager)), gameConfig);
        this.initializePlayer(this.organizer as Player);
        this.organizer = new MockClient();
    }

    survivedRound() {
        this.roundSurvived += 1;
        this.player?.emitToUser(GamePlayerSocketEvent.SurvivedRound, true);
    }

    failedRound() {
        this.isAlive = false;
        this.player?.emitToUser(GamePlayerSocketEvent.SurvivedRound, false);
        this.player?.emitToUser(GamePlayerSocketEvent.EliminatePlayer, 0);
    }

    setUp() {
        super.setUp();
        this.showNextQuestion();
    }

    continueQuiz(): void {
        if (!this.isAlive) return this.onFinishedAllQuestions();
        if (this.player) this.player.roundSurvived += 1;
        super.continueQuiz();
    }

    correctionWasFinished(): void {
        super.correctionWasFinished();
        this.continueQuiz();
    }

    onFinishedGame() {
        Container.get(UsersStatsService).updateBestSurvivalScore(this.player?.id, this.roundSurvived).then((userStats) => {
            this.player?.emitToUser(GamePlayerSocketEvent.SurvivalResult, userStats.bestSurvivalScore);
        });
        super.onFinishedGame();
    }

    getGameResult(): { winner?: Player, wasTie: boolean } {
        return { winner: this.isAlive ? this.player : undefined, wasTie: false };
    }

    protected shouldGoToCorrectionState(): boolean {
        return false;
    }

    private initializePlayer(player: Player) {
        this.players = [player];

        const gameInfo: GameInfo = {
            gameId: this.gameId,
            quizToPlay: this.quiz,
            gameType: GameType.SurvivalGame,
            isLocked: true,
            playersNb: 1,
            entryFee: 0,
        };
        player.emitToUser(GamePlaySocketEvent.SendGameInfo, gameInfo);
        this.updateUserRole(player, UserGameRole.Player);
    }
}
