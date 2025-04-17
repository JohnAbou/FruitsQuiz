import { Component } from '@angular/core';
import { QuestionService } from '@app/services/question-services/question.service';
import { QuestionType } from '@common/enums/question-type';

@Component({
	selector: 'app-survival-quiz-header',
	templateUrl: './survival-quiz-header.component.html',
	styleUrls: ['./survival-quiz-header.component.scss']
})
export class SurvivalQuizHeaderComponent {

	get totalQuestions(): number {
		const questions = this.questionService.getQuestions();
		return questions.filter((question) => question.type === QuestionType.QCM || question.type === QuestionType.QRE).length;
	}

	get isActivated(): boolean {
		return this.totalQuestions >= 5;
	}

	constructor(private readonly questionService: QuestionService) { }
}
