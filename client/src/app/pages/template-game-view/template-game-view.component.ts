import { Component, HostListener } from '@angular/core';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { GameStateService } from '@app/services/game-services/game-state.service';
import { QuestionType } from '@common/enums/question-type';
import { UserGameRole } from '@common/enums/user-game-role';
import { Question } from '@common/interfaces/question';
import { TranslateService } from '@ngx-translate/core';
import { Subscription } from 'rxjs';

@Component({
	selector: 'app-template-game-view',
	templateUrl: './template-game-view.component.html',
	styleUrls: ['./template-game-view.component.scss']
})
export class TemplateGameViewComponent {
	question: Question;

	userRole: UserGameRole = UserGameRole.None;
	subscription: Subscription;

	get gameType() {
		return this.gameInfoService.getGameType();
	}

	constructor(
		private gameManager: GameManagerService,
		private modalService: DialogModalService,
		private translate: TranslateService,
		private gameInfoService: GameInfoService,
		gameUserState: GameStateService,
	) {
		this.subscription = gameUserState.getRoleObservable()
			.subscribe((newRole) => this.userRole = newRole);
	}

	ngOnDestroy() {
		this.subscription?.unsubscribe();
	}

	@HostListener('window:keydown', ['$event'])
	buttonDetect(event: KeyboardEvent) {
		if (this.shouldIgnoreEvent(event)) return;

		if (this.question.type == QuestionType.QRL) return;

		event.preventDefault();
		this.submitButtonHandler();
	}

	ngOnInit() {
		this.question = this.gameManager.getCurrentQuestion();
	}
	

	submitButtonHandler() {
		this.openSubmitConfirmationSnackBar();
		this.submitAnswer();
	}

	canSubmitAnswer() {
		return this.gameManager.canSubmitAnswer();
	}

	private submitAnswer() {
		this.gameManager.submitAnswers();
	}

	private openSubmitConfirmationSnackBar() {
		if (!this.canSubmitAnswer()) return;
		this.modalService.openSnackBar(this.translate.instant('PlayerGameView.AnswersSent'));
	}

	private shouldIgnoreEvent(event: KeyboardEvent): boolean {
		const target = event.target as HTMLElement;
		if (event.key !== 'Enter') return true;
		return target.tagName === 'INPUT' || target.tagName === 'TEXTAREA';
	}
}
