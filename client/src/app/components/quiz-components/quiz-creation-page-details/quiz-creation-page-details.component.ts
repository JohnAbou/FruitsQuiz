import { Component, OnDestroy } from '@angular/core';
import { GameCreationService } from '@app/services/game-services/game-creation.service';

@Component({
	selector: 'app-quiz-creation-page-details',
	templateUrl: './quiz-creation-page-details.component.html',
	styleUrls: ['./quiz-creation-page-details.component.scss']
})
export class QuizCreationPageDetailsComponent implements OnDestroy {
	
	get selectedQuiz() {
		return this.gameCreationService.selectedQuiz;
	}

	get isRandomQuizSelected() {
		return this.gameCreationService.isRandomQuizSelected;
	}

	get isSurvivalQuizSelected() {
		return this.gameCreationService.isSurvivalQuizSelected;
	}

	constructor(private readonly gameCreationService: GameCreationService) { }

	ngOnDestroy(): void {
		this.backToList();
	}

	backToList(): void {
        this.gameCreationService.selectedQuiz = null;
        this.gameCreationService.isRandomQuizSelected = false;
		this.gameCreationService.isSurvivalQuizSelected = false;
    }

}
