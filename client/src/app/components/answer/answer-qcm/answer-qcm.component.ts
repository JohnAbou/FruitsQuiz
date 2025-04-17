import { Component, HostListener, Input, OnDestroy, OnInit } from '@angular/core';
import { GameCorrectedAnswerService } from '@app/services/game-services/game-corrected-answer.service';
import { GameCurrentQuestionService } from '@app/services/game-services/game-current-question.service';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { map, Observable, Subscription } from 'rxjs';

@Component({
    selector: 'app-answer-qcm',
    templateUrl: './answer-qcm.component.html',
    styleUrls: ['./answer-qcm.component.scss'],
})
export class AnswerQcmComponent implements OnInit, OnDestroy {
    @Input() isInteractive = false;

    private selectedAnswers: number[] = [];
    private subscription: Subscription;

    get question() {
        return this.gameCurrentQuestion.getCurrentQuestionObservable();
    }

    get deactivatedButton() {
        return this.gameManager.getHintReceivedObservable();
    }

    constructor(
        private gameManager: GameManagerService,
        private gameCorrectedAnswer: GameCorrectedAnswerService,
        private gameCurrentQuestion: GameCurrentQuestionService,
    ) {
        this.selectedAnswers = [];
    }

    ngOnInit(): void {
        this.subscription = this.gameManager.getHintReceivedObservable().subscribe((hintIndex) => {
            if (this.selectedAnswers.indexOf(hintIndex) === -1) return;
            this.toggleButton(hintIndex);
        });
    }

    ngOnDestroy(): void {
        this.subscription.unsubscribe();
    }

    get answerOptions(): Observable<string[]> {
        return this.question.pipe(
            map((question) => question.choices.map((choice) => choice.text))
        );
    }

    get totalChoices(): Observable<number> {
        return this.question.pipe(
            map((question) => question.choices.length)
        );
    }

    @HostListener('window:keydown', ['$event'])
    buttonDetect(event: KeyboardEvent) {
        if (this.shouldIgnoreEvent(event)) return;

        const buttonId = parseInt(event.key) - 1;
        if (!isNaN(buttonId) && buttonId >= 0) {
            this.toggleButton(buttonId);
        }
    }

    isButtonHinted(button: number): Observable<boolean> {
        return this.deactivatedButton.pipe(map((index) => index === button));
    }

    isButtonActive(button: number): boolean {
        return this.selectedAnswers.includes(button) && !this.gameCorrectedAnswer.shouldShowCorrectedAnswer();
    }

    isButtonCorrected(buttonIndex: number): boolean {
        return this.gameCorrectedAnswer.isAnswerCorrected(buttonIndex);
    }

    canSubmitAnswer() {
        return this.gameManager.canSubmitAnswer();
    }

    toggleButton(buttonId: number): void {
        if (!this.isInteractive || !this.canSubmitAnswer()) return;

        const button = document.querySelectorAll('.answer-buttons')[buttonId] as HTMLElement;
        const text = button.textContent || '';
        const length = text.length;
        button.style.setProperty('--length', length.toString());

        const index = this.selectedAnswers.indexOf(buttonId);

        if (index === -1) {
            // Add the answer (no more restrictions)
            this.selectedAnswers.push(buttonId);
            this.gameManager.toggleAnswerChoice(buttonId);
        } else {
            // Always allow deselection
            this.selectedAnswers.splice(index, 1);
            this.gameManager.toggleAnswerChoice(buttonId);
        }
    }

    private shouldIgnoreEvent(event: KeyboardEvent): boolean {
        if (!this.isInteractive) return false;
        const target = event.target as HTMLElement;
        return target.tagName === 'INPUT' || target.tagName === 'TEXTAREA';
    }
}
