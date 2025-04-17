import { Component } from '@angular/core';
import { GameCreationService } from '@app/services/game-services/game-creation.service';

@Component({
	selector: 'app-survival-quiz-details',
	templateUrl: './survival-quiz-details.component.html',
	styleUrls: ['./survival-quiz-details.component.scss']
})
export class SurvivalQuizDetailsComponent {
	constructor(private readonly gameCreationService: GameCreationService) { }

    backToList(): void {
        this.gameCreationService.selectedQuiz = null;
        this.gameCreationService.isRandomQuizSelected = false;
        this.gameCreationService.isSurvivalQuizSelected = false;
    }
}
