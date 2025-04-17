import { Player } from "@app/interfaces/users/player";
import { GameLobby } from "../game/game-lobby";
import { Challenge } from "./challenge";

export class AnswerTimeChallenge extends Challenge {

    isAvailable(game: GameLobby): boolean {
        return true;
    }

    isValidated(player: Player) {
        return player.averageAnswerTime <= 5;
    }

    getInfo(): { code: number, price: number } {
        return { code: 2, price: 4 };
    }
}