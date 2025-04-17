import { GameSessionBase } from '@app/classes/game/game-session-base';
import Container, { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { Challenge } from '@app/classes/challenges/challenge';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { AnswerCollector } from './answer-collector';
import { UserDataManager } from '@app/services/data/user-data-manager.service';
import { UsersStatsService } from '@app/services/users/user-stats-service';

@Service({ transient: true })
export class GameChallengesValidator extends BaseGameObserver {

    private challenges: Map<string, Challenge> = new Map();

    constructor(
        game: GameSessionBase,
        private readonly answerCollector: AnswerCollector,
        challenges: Map<string, Challenge>) 
    {
        super(game);
        this.challenges = challenges;

        answerCollector.answerCorrectedSubject.subscribe(() => this.updateChallengeStatus());
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        let subscriptions = [
            game.quizEndedSubject.subscribe(() => {
                this.validateChallenges();
            }),
            game.removedGameSubject.subscribe(() => {
                subscriptions.forEach((subscription) => subscription.unsubscribe());
            }),
        ];
    }

    private updateChallengeStatus() {
        const { incorrectPlayers, playersWhoInteracted, lastToAnswer } = this.answerCollector.getPlayersAnswerResult();

        this.challenges.forEach((challenge, playerId) => {
            challenge.updateStatus(
                this.game.getQuestion(),
                playersWhoInteracted.has(playerId) && !incorrectPlayers.has(playerId),
                playersWhoInteracted.has(playerId),
                lastToAnswer === playerId,
            );

        });
    }

    private validateChallenges() {
        let userDataManager = Container.get(UserDataManager);
        let userStatsService = Container.get(UsersStatsService);

        this.challenges.forEach((challenge, playerId) => {
            const player = this.game.getUser(playerId);
            if (!player) return;
            
            const isValidated = challenge.isValidated(player);

            if (isValidated) {
                userDataManager.addUserCurrency(playerId, challenge.getInfo().price);
                userStatsService.incrementChallengeCompleted(playerId);
            }

            player.emitToUser(GamePlayerSocketEvent.SendChallengeResult, { success: isValidated });
        });
    }
}
