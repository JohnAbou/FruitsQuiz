import { Component, OnDestroy } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { InformationModalComponent } from '@app/components/modal/information-modal/information-modal.component';
import { ELIMINATION_QUIZ_ID, SURVIVAL_QUIZ_ID } from '@common/config/game-config';
import { GameCreationService } from '@app/services/game-services/game-creation.service';
import { QuizService } from '@app/services/quiz-services/quiz.service';
import { GameType } from '@common/enums/game-type';
import { Quiz } from '@common/interfaces/quiz';
import { Subscription } from 'rxjs';
import { QuestionService } from '@app/services/question-services/question.service';
import { TranslateService } from '@ngx-translate/core';
import { QuestionType } from '@common/enums/question-type';
import { Router } from '@angular/router';
import { DialogModalService } from '@app/services/dialog-modal.service';

type GameMode = 'classic' | 'elimination' | 'survival' | null;

@Component({
    selector: 'app-game-creation-page',
    templateUrl: './game-creation-page.component.html',
    styleUrls: ['./game-creation-page.component.scss']
})
export class GameCreationPageComponent implements OnDestroy {
    protected readonly Math = Math;
    quizzes: Quiz[] = [];
    selectedGameMode: GameMode = null;

    readonly quizSubscription: Subscription = new Subscription();
    readonly MIN_QUESTIONS = 5;

    get selectedQuiz() {
        return this.gameCreationService.selectedQuiz;
    }

    get isFriendsOnly() {
        return this.gameCreationService.isFriendsOnly;
    }

    get entryPrice() {
        return this.gameCreationService.entryFee;
    }

    set entryPrice(price: number) {
        this.gameCreationService.entryFee = price;
    }

    get questionCount() {
        return this.gameCreationService.questionCount;
    }

    set questionCount(count: number) {
        this.gameCreationService.questionCount = count;
    }

    get availableQuestionsCount() {
        return this.countAutoCorrectQuestions();
    }

    constructor(
        private dialog: MatDialog,
        private quizService: QuizService,
        private gameCreationService: GameCreationService,
        private questionService: QuestionService,
        private translate: TranslateService,
        private router: Router,
        private dialogModalService: DialogModalService
    ) {
        this.updateQuizzes();
        this.quizSubscription = this.quizService.getQuizModificationObservable().subscribe(() => {
            this.handleQuizServiceEvent();
        });
    }

    selectGameMode(mode: GameMode) {
        if (mode === 'elimination' || mode === 'survival') {
            if (!this.areSpecialQuizAvailable()) return;
        }
        
        this.selectedGameMode = mode;
        this.gameCreationService.selectedQuiz = null;
        this.gameCreationService.isRandomQuizSelected = mode === 'elimination';
        this.gameCreationService.isSurvivalQuizSelected = mode === 'survival';
        
        if (mode === 'survival') {
            this.gameCreationService.entryFee = 0;
        }
    }

    backToModeSelection() {
        this.selectedGameMode = null;
        this.gameCreationService.selectedQuiz = null;
        this.gameCreationService.isRandomQuizSelected = false;
        this.gameCreationService.isSurvivalQuizSelected = false;
    }

    toggleFriendGame(isFriends: boolean) {
        this.gameCreationService.isFriendsOnly = isFriends;
    }

    currentQuizRemoved(): void {
        this.gameCreationService.selectedQuiz = null;
        this.dialog.open(InformationModalComponent, { data: this.translate.instant('QuizValidationError.UnavailableQuiz')});
    }

    selectQuiz(quiz: Quiz): void {
        this.gameCreationService.selectedQuiz = quiz;
    }

    unselectQuiz(): void {
        this.gameCreationService.selectedQuiz = null;
    }

    getQuestionTypeLabel(type: QuestionType): string {
        switch (type) {
            case QuestionType.QCM:
                return this.translate.instant('QuestionTypes.QCMDescription');
            case QuestionType.QRL:
                return this.translate.instant('QuestionTypes.QRLDescription');
            case QuestionType.QRE:
                return this.translate.instant('QuestionTypes.QREDescription');
            default:
                return type;
        }
    }

    areButtonDisabled(): boolean {
        if (this.selectedGameMode === 'classic') {
            return !this.selectedQuiz;
        }
        return false;
    }

    areSpecialQuizAvailable(): boolean {
        return this.countAutoCorrectQuestions() >= 5;
    }

    ngOnDestroy(): void {
        this.gameCreationService.isFriendsOnly = false;
        this.gameCreationService.questionCount = 5;
        this.gameCreationService.entryFee = 0;
        this.backToModeSelection();
        this.quizSubscription.unsubscribe();
    }

    createGame(): void {
        if (this.questionCount < this.MIN_QUESTIONS) {
            this.dialogModalService.openSnackBar(
                this.translate.instant('GameCreation.MinimumQuestionsError', { min: this.MIN_QUESTIONS })
            );
            return;
        }

        let result = false;
        switch (this.selectedGameMode) {
            case 'elimination':
                result = this.gameCreationService.createGame(ELIMINATION_QUIZ_ID, GameType.EliminationGame);
                break;
            case 'survival':
                result = this.gameCreationService.createGame(SURVIVAL_QUIZ_ID, GameType.SurvivalGame);
                break;
            case 'classic':
                if (this.selectedQuiz) {
                    result = this.gameCreationService.createGame(this.selectedQuiz.id, GameType.NormalGame);
                }
                break;
        }
        if (result) this.router.navigate(['/game-view']);
    }

    private handleQuizServiceEvent(): void {
        const previouslySelectedQuiz = this.selectedQuiz;
        this.updateQuizzes();

        if (!previouslySelectedQuiz) return;

        const updatedSelectedQuiz = this.quizzes.find((quiz) => quiz.id === previouslySelectedQuiz.id);
        if (!updatedSelectedQuiz) return this.currentQuizRemoved();

        this.gameCreationService.selectedQuiz = updatedSelectedQuiz;
    }

    private updateQuizzes(): void {
        this.quizzes = this.quizService.getAllQuiz();
    }

    private countAutoCorrectQuestions() {
        const questions = this.questionService.getQuestions();
        return questions.filter((question) => question.type === QuestionType.QCM || question.type === QuestionType.QRE).length;
    }
}