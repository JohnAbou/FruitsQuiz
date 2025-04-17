import { Player } from "@app/interfaces/users/player";
import { GameLobby } from "../game/game-lobby";
import { Challenge } from "./challenge";
import { Question } from "@common/interfaces/question";
import { GameType } from "@common/enums/game-type";

export class LastToAnswerChallenge extends Challenge {

    private failed = false;

    isAvailable(game: GameLobby): boolean {
        return game.futureGameType === GameType.NormalGame;
    }

    isValidated(player: Player) {
        return !this.failed;
    }

    getInfo(): { code: number, price: number } {
        return { code: 7, price: 3 };
    }

    updateStatus(question: Question, wasCorrect: boolean, answered: boolean, lastToAnswer: boolean) {
        this.failed ||= lastToAnswer || !answered;
    }
}