import { Player } from '@app/interfaces/users/player';
import { GameSessionBase } from './game-session-base';

export class GameSessionNormal extends GameSessionBase {
    private canGoToNextQuestion: boolean = false;

    setUp(): void {
        super.setUp();
        this.showLoading();
    }

    continueQuiz() {
        if (!this.canGoToNextQuestion) return;
        super.continueQuiz();
    }

    correctionWasFinished(): void {
        super.correctionWasFinished();
        this.canGoToNextQuestion = true;
    }

    getGameResult(): { winner?: Player, wasTie: boolean } {
        if (this.players.length === 0) {
            return { wasTie: false };
        }
    
        const bestPlayer = this.players.reduce((bestPlayer, currentPlayer) => {
            if (
                (currentPlayer.score ?? 0) > (bestPlayer.score ?? 0) ||
                ((currentPlayer.score ?? 0) === (bestPlayer.score ?? 0) &&
                    currentPlayer.averageAnswerTime < bestPlayer.averageAnswerTime)
            ) {
                return currentPlayer;
            }
            return bestPlayer;
        });
    
        const isTie = this.players.some(player => (player.score ?? 0) === (bestPlayer.score ?? 0) && player !== bestPlayer);
    
        return {
            winner: bestPlayer,
            wasTie: isTie
        };
    }

    protected nextQuestionTransition() {
        this.showIntermission();
    }

    protected showNextQuestion() {
        this.canGoToNextQuestion = false;
        super.showNextQuestion();
    }

    protected onFinishedAllQuestions(): void {
        super.onFinishedGame();
    }
}
