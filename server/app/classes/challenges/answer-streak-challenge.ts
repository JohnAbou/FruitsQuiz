import { Player } from "@app/interfaces/users/player";
import { GameLobby } from "../game/game-lobby";
import { Challenge } from "./challenge";
import { Question } from "@common/interfaces/question";
import { GameType } from "@common/enums/game-type";

export class AnswerStreakChallenge extends Challenge {

    private currentStreak: number = 0;
    private maxStreak: number = 0;

    isAvailable(game: GameLobby): boolean {
        return game.quiz.questions.length >= 3 && game.futureGameType != GameType.EliminationGame;
    }

    isValidated(player: Player) {
        return this.maxStreak >= 3;
    }

    getInfo(): { code: number, price: number } {
        return { code: 1, price: 5 };
    }

    updateStatus(question: Question, wasCorrect: boolean, answered: boolean, lastToAnswer: boolean) {
        if (wasCorrect) {
            this.currentStreak++;
            this.maxStreak = Math.max(this.maxStreak, this.currentStreak);
        } else {
            this.currentStreak = 0;
        }
    }
}