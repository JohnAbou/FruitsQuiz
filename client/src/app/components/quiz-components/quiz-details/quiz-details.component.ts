import { Component, Input } from '@angular/core';
import { GameCreationService } from '@app/services/game-services/game-creation.service';
import { Quiz } from '@common/interfaces/quiz';

@Component({
    selector: 'app-quiz-details',
    templateUrl: './quiz-details.component.html',
    styleUrls: ['./quiz-details.component.scss'],
})
export class QuizDetailsComponent {
    @Input() quiz: Quiz;

    constructor(private readonly gameCreationService: GameCreationService) { }

    backToList(): void {
        this.gameCreationService.selectedQuiz = null;
        this.gameCreationService.isRandomQuizSelected = false;
        this.gameCreationService.isSurvivalQuizSelected = false;
    }
}
