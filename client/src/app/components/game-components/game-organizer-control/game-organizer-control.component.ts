import { Component } from '@angular/core';
import { GameOrganiserManagerService } from '@app/services/game-services/game-organiser-manager.service';

@Component({
	selector: 'app-game-organizer-control',
	templateUrl: './game-organizer-control.component.html',
	styleUrls: ['./game-organizer-control.component.scss']
})
export class GameOrganizerControlComponent {
	constructor(private readonly gameOrganiserManager: GameOrganiserManagerService) { }

	isNextQuestionButtonActive() {
		return this.gameOrganiserManager.isNextQuestionButtonActive();
	}

	goToNextQuestion() {
		this.gameOrganiserManager.goToNextQuestion();
	}
}
