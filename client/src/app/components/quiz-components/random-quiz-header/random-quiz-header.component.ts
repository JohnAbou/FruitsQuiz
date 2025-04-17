import { Component } from '@angular/core';
import { QuestionService } from '@app/services/question-services/question.service';
import { QuestionType } from '@common/enums/question-type';

@Component({
    selector: 'app-random-quiz-header',
    templateUrl: './random-quiz-header.component.html',
    styleUrls: ['./random-quiz-header.component.scss'],
})
export class RandomQuizHeaderComponent {
    get totalQuestions(): number {
        const questions = this.questionService.getQuestions();
        return questions.filter((question) => question.type === QuestionType.QCM || question.type === QuestionType.QRE).length;
    }

    get isActivated(): boolean {
        return this.totalQuestions >= 5;
    }

    constructor(private readonly questionService: QuestionService) { }
}
