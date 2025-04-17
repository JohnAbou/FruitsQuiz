import { Question } from '@common/interfaces/question';
import { Player } from '@app/interfaces/users/player';
import { Service } from 'typedi';
import { FIRST_ANSWER_BONUS } from '@app/consts/game.const';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { GameMessage } from '@app/interfaces/game-message';

@Service({ transient: true })
export class AnswerQRECorrectorService {
    private question!: Question;

    setQuestion(question: Question): void {
        this.question = question;
    }

    scorePlayerAnswer(player: Player, playerAnswer: number, deserveBonus: boolean): void {
        const { lowerBound, upperBound, exactValue, toleranceMargin } = this.question.estimations!;

        if (playerAnswer < lowerBound || playerAnswer > upperBound) {
            return this.sendCorrectionMessage(player, 0, false);
        }

        const baseScore = this.computeScore(playerAnswer);

        const bonusEligible = playerAnswer === exactValue && toleranceMargin > 0 && deserveBonus;
        const finalScore = bonusEligible ? this.getScoreWithBonus(baseScore) : baseScore;

        this.sendCorrectionMessage(player, finalScore, bonusEligible);
        this.updatePlayerState(player, finalScore, bonusEligible);
    }

    private computeScore(playerAnswer: number): number {
        const { exactValue, toleranceMargin } = this.question.estimations!;
        const fullPoints = this.question.points;
        const absError = Math.abs(playerAnswer - exactValue);

        if (absError <= toleranceMargin) {
            return fullPoints;
        }

        return 0;
    }

    isAnswerCorrect(playerAnswer: number): boolean {
        return this.validateAnswer(playerAnswer);
    }

    isAnswerExact(value: number): boolean {
        const { exactValue } = this.question.estimations!;
        return value === exactValue;
    }

    private validateAnswer(playerAnswer: number): boolean {
        if (typeof playerAnswer !== 'number') return false;
        const { exactValue, toleranceMargin } = this.question.estimations!;
        const absError = Math.abs(playerAnswer - exactValue);
        return absError <= toleranceMargin;
    }

    private updatePlayerState(player: Player, scoreGained: number, gotBonus: boolean): void {
        if (gotBonus) player.bonusCount++;
        player.score += scoreGained;
    }

    private getScoreWithBonus(baseScore: number): number {
        return Math.round(baseScore * FIRST_ANSWER_BONUS);
    }

    private sendCorrectionMessage(player: Player, score: number, gotBonus: boolean): void {
        const message: GameMessage = {
            code: gotBonus ? 20000 : 20005,
            values: { score },
        }
        player.emitToUser(GameAnswerSocketEvent.SendCorrectionMessage, message);
    }
}
