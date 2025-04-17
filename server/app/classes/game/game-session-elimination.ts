import { Player } from '@app/interfaces/users/player';
import { GameSessionBase } from './game-session-base';
import { TimerService } from '@app/services/timer.service';
import { GameQuizHandlerService } from '@app/services/game/game-quiz-handler.service';
import { GameConfig } from '@app/interfaces/game-config';
import { UserGameRole } from '@common/enums/user-game-role';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { translatePlayer, translatePlayers } from '@app/utils/translate.utils';
import { MockClient } from '../mock-client';
import { GameEntryFeeService } from '@app/services/game/game-entry-fee.service';

export enum EliminationReason {
    WrongAnswer = 1,
    LastToAnswer = 2,
    NoAnswer = 3,
}

export class GameSessionElimination extends GameSessionBase {
    private eliminatedPlayers: Set<Player> = new Set();

    get activePlayers() {
        return this.players.filter((player) => !this.eliminatedPlayers.has(player));
    }

    constructor(
        timerService: TimerService,
        quizHandler: GameQuizHandlerService,
        entryFeeManager: GameEntryFeeService,
        gameConfig: GameConfig,
    ) {
        super(timerService, quizHandler, entryFeeManager, gameConfig);
        this.updateUserRole(gameConfig.organizer, UserGameRole.Player);
        this.entryFeeManager.attemptToJoin(gameConfig.organizer);
    }

    isEliminated(player: Player): boolean {
        return this.eliminatedPlayers.has(player);
    }

    setUp(): void {
        super.setUp();
        this.showLoading();
    }

    setPlayers(players: Player[]) {
        const organizerAsPlayer = this.organizer as Player;
        this.organizer = new MockClient();

        this.players = [...players, organizerAsPlayer];
        this.players.forEach((player) => player.emitToUser(GamePlayerSocketEvent.SendPlayerJoined, translatePlayer(organizerAsPlayer)));
    }

    eliminatePlayer(player: Player, reason: EliminationReason): void {
        if (this.eliminatedPlayers.has(player)) return;
        this.eliminatedPlayers.add(player);

        this.updateUserRole(player, UserGameRole.Observer);
        player.emitToUser(GamePlayerSocketEvent.EliminatePlayer, reason);
    }

    continueQuiz(): void {
        this.activePlayers.forEach((player) => player.roundSurvived += 1);
        this.users.forEach((user) => user.emitToUser(GamePlayerSocketEvent.SendPlayerStats, translatePlayers(this.players)))

        if (!this.activePlayers.length)
            return this.onFinishedAllQuestions();

        super.continueQuiz();
    }

    getGameResult(): { winner?: Player, wasTie: boolean } {
        if (this.players.length === 0) {
            return { wasTie: false };
        }
    
        const bestPlayer = this.players.reduce((bestPlayer, currentPlayer) => {
            if (
                (currentPlayer.roundSurvived ?? 0) > (bestPlayer.roundSurvived ?? 0) ||
                ((currentPlayer.roundSurvived ?? 0) === (bestPlayer.roundSurvived ?? 0) &&
                    currentPlayer.averageAnswerTime < bestPlayer.averageAnswerTime)
            ) {
                return currentPlayer;
            }
            return bestPlayer;
        });
    
        const isTie = this.players.some(player => (player.roundSurvived ?? 0) === (bestPlayer.roundSurvived ?? 0) && player !== bestPlayer);
    
        return {
            winner: bestPlayer,
            wasTie: isTie
        };
    }

    protected shouldGoToCorrectionState(): boolean {
        return false;
    }
}
