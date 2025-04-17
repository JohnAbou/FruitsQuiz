import { Component } from '@angular/core';
import { GameCreationService } from '@app/services/game-services/game-creation.service';

@Component({
    selector: 'app-random-quiz-details',
    templateUrl: './random-quiz-details.component.html',
    styleUrls: ['./random-quiz-details.component.scss'],
})
export class RandomQuizDetailsComponent {
    constructor(private readonly gameCreationService: GameCreationService) { }

    backToList(): void {
        this.gameCreationService.selectedQuiz = null;
        this.gameCreationService.isRandomQuizSelected = false;
        this.gameCreationService.isSurvivalQuizSelected = false;
    }
}
