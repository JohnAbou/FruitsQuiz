import { Component } from '@angular/core';
import { GameCreationService } from '@app/services/game-services/game-creation.service';
import { QuestionService } from '@app/services/question-services/question.service';
import { QuestionType } from '@common/enums/question-type';

@Component({
	selector: 'app-question-count-selection',
	templateUrl: './question-count-selection.component.html',
	styleUrls: ['./question-count-selection.component.scss']
})
export class QuestionCountSelectionComponent {
	get totalQuestions(): number {
		const questions = this.questionService.getQuestions();
		return questions.filter((question) => question.type === QuestionType.QCM || question.type === QuestionType.QRE).length;
	}

	get count() {
		return this.gameCreationService.questionCount;
	}

	set count(value: number) {
		this.gameCreationService.questionCount = value;
	}

	constructor(
		private readonly questionService: QuestionService,
		private readonly gameCreationService: GameCreationService,
	) { }

	updateCount(newCount: number) {
		this.count = newCount > 0
			? Math.min(this.totalQuestions, this.count + newCount)
			: Math.max(5, this.count + newCount)
	}
}
