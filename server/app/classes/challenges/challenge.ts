import { Player } from "@app/interfaces/users/player";
import { GameLobby } from "../game/game-lobby";
import { Question } from "@common/interfaces/question";

export abstract class Challenge {
    abstract isAvailable(game: GameLobby): boolean;
    abstract isValidated(player: Player): boolean;
    abstract getInfo(): { code: number, price: number };

    updateStatus(question: Question, wasCorrect: boolean, answered: boolean, lastToAnswer: boolean) {}
}