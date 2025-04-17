import { QuestionType } from "@common/enums/question-type";
import { GameLobby } from "../game/game-lobby";
import { Challenge } from "./challenge";
import { Player } from "@app/interfaces/users/player";
import { GameType } from "@common/enums/game-type";

export class BonusChallenge extends Challenge {

    private neededBonus: number = 0;

    isAvailable(game: GameLobby): boolean {
        if (game.futureGameType === GameType.EliminationGame) return false;
        const bonusQuestion = game.quiz.questions.filter((question) => question.type === QuestionType.QCM || question.type === QuestionType.QRE).length;
        this.neededBonus = bonusQuestion / 2;
        return bonusQuestion >= 2;
    }

    isValidated(player: Player): boolean {
        return player.bonusCount >= this.neededBonus;
    }

    getInfo(): { code: number, price: number } {
        return { code: 3, price: 8 };
    }

}