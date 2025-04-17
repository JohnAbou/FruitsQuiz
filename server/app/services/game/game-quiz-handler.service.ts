import { QuestionWithIndex } from '@common/interfaces/question';
import { Quiz } from '@common/interfaces/quiz';
import { Service } from 'typedi';

@Service({ transient: true })
export class GameQuizHandlerService {
    private questionIndex: number;
    private quiz: Quiz;

    constructor(quiz: Quiz) {
        this.questionIndex = 0;
        this.quiz = quiz;
    }

    goToNextQuestion() {
        ++this.questionIndex;
    }

    isQuizFinished(): boolean {
        return this.questionIndex >= this.quiz.questions.length;
    }

    getQuestion(): QuestionWithIndex {
        return this.isQuizFinished() ?
            { ...this.quiz.questions[this.quiz.questions.length-1], index: this.quiz.questions.length-1 }
            : { ...this.quiz.questions[this.questionIndex], index: this.questionIndex };
    }
}
