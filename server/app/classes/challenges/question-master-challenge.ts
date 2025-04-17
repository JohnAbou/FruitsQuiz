import { Player } from "@app/interfaces/users/player";
import { GameLobby } from "../game/game-lobby";
import { Challenge } from "./challenge";
import { Question } from "@common/interfaces/question";
import { QuestionType } from "@common/enums/question-type";


export class QuestionMasterChallenge extends Challenge {
    private failed = false;

    constructor(private readonly questionType: QuestionType, private readonly code: number) {
        super();
    }

    isAvailable(game: GameLobby): boolean {
        return game.quiz.questions.filter(question => question.type === this.questionType).length >= 3;
    }

    isValidated(player: Player) {
        return !this.failed;
    }

    getInfo(): { code: number, price: number } {
        return { code: this.code, price: 4 };
    }

    updateStatus(question: Question, wasCorrect: boolean, answered: boolean) {
        this.failed ||= question.type === this.questionType && !wasCorrect;
    }
}


export class QCMMasterChallenge extends QuestionMasterChallenge {
    constructor() { super(QuestionType.QCM, 4); }
}

export class QRLMasterChallenge extends QuestionMasterChallenge {
    constructor() { super(QuestionType.QRL, 5); }
}

export class QREMasterChallenge extends QuestionMasterChallenge {
    constructor() { super(QuestionType.QRE, 6); }
}