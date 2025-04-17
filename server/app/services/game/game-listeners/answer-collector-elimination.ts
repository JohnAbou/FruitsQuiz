import { GameSessionBase } from '@app/classes/game/game-session-base';
import Container, { Service } from 'typedi';
import { AnswerManagerQCM } from './answer-managers/answer-manager-qcm.service';
import { AnswerManagerQRL } from './answer-managers/answer-manager-qrl.service';
import { AnswerManagerQRE } from './answer-managers/answer-manager-qre.service';
import { AnswerCollector } from './answer-collector';
import { EliminationReason, GameSessionElimination } from '@app/classes/game/game-session-elimination';
import { Player } from '@app/interfaces/users/player';
import { BotAnswerService } from '../answer/bot-answer.service';
import { AnswerTimerService } from '../answer/answer-timer.service';
import { UsersStatsService } from '@app/services/users/user-stats-service';

@Service({ transient: true })
export class AnswerCollectorElimination extends AnswerCollector {
    private eliminated = false;

    private get eliminationGame() {
        return this.game as GameSessionElimination;
    }

    private get noSubmissionsPlayers() {
        return this.players.filter((player) => !this.playersWhichSubmited.has(player));
    }

    constructor(
        game: GameSessionBase,
        answerManagerQRL: AnswerManagerQRL,
        answerManagerQCM: AnswerManagerQCM,
        answerManagerQRE: AnswerManagerQRE,
        botAnswerService: BotAnswerService,
        answerTimerService: AnswerTimerService,
    ) {
        super(game, answerManagerQRL, answerManagerQCM, answerManagerQRE, botAnswerService, answerTimerService);
    }

    protected questionEnded() {
        const playersWichInteracted = this.answerManager.getPlayersWhoInteracted();
        const noIteractionPlayers = this.noSubmissionsPlayers.filter((player) => !playersWichInteracted.has(player));

        this.attemptElimination(this.filterOnlyActivePlayers(noIteractionPlayers), EliminationReason.NoAnswer);
        super.questionEnded();
    }

    protected onCorrectionFinished() {
        this.updateUserStats();
        const incorrectPlayers = this.filterOnlyActivePlayers(this.answerManager.getIncorrectPlayers());
        this.attemptElimination(incorrectPlayers, EliminationReason.WrongAnswer);

        if (!this.eliminated) this.attemptElimination(this.filterOnlyActivePlayers(this.noSubmissionsPlayers), EliminationReason.LastToAnswer);

        if (!this.eliminated && this.lastToAnswer) this.eliminationGame.eliminatePlayer(this.lastToAnswer, EliminationReason.LastToAnswer);

        super.onCorrectionFinished();
        this.eliminationGame.continueQuiz();
    }

    protected submitPlayerAnswer(player: Player) {
        if (this.eliminationGame.isEliminated(player)) return;
        super.submitPlayerAnswer(player);
    }

    protected verifyIfIsLastAnswer() {
        const activePlayers = this.eliminationGame.activePlayers;
        if (this.playersWhichSubmited.size === activePlayers.length) this.game.allPlayerHaveSubmited();
    }

    protected resetAnswer() {
        super.resetAnswer();
        this.eliminated = false;
    }

    private filterOnlyActivePlayers(players: Player[]) {
        let activePlayers = new Set(this.eliminationGame.activePlayers);
        return players.filter((player) => activePlayers.has(player));
    }

    private attemptElimination(players: Player[], reason: EliminationReason) {
        if (!players.length) return;

        this.eliminated = true;
        players.forEach((player) => this.eliminationGame.eliminatePlayer(player, reason));
    }

    protected updateUserStats() {
        const { incorrectPlayers } = this.getPlayersAnswerResult();

        this.game.realPlayers.forEach((player) => {
            if (this.eliminationGame.isEliminated(player)) return;
            incorrectPlayers.has(player.id)
                ? Container.get(UsersStatsService).incrementFailedQuestion(player.id)
                : Container.get(UsersStatsService).incrementGottenQuestion(player.id);
        });
    }
}
