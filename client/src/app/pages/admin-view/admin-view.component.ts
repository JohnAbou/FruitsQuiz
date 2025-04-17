import { Component, OnDestroy, OnInit } from '@angular/core';
import { Quiz } from '@common/interfaces/quiz';
import { QuizService } from '@app/services/quiz-services/quiz.service';
import { QuizValidationService } from '@app/services/quiz-services/quiz-validation.service';
import { Subscription } from 'rxjs';
import { UserInfoService } from '@app/services/user-info.service';
import { Router } from '@angular/router';
@Component({
    selector: 'app-admin-view',
    templateUrl: './admin-view.component.html',
    styleUrls: ['./admin-view.component.scss'],
})
export class AdminViewComponent implements OnInit, OnDestroy {
    quizzes: Quiz[];
    readonly quizSubscription: Subscription = new Subscription();

    constructor(
        private quizService: QuizService,
        private quizValidationService: QuizValidationService,
        private userService: UserInfoService,
        private router: Router
    ) {
        this.updateQuizzes();
        this.quizSubscription = this.quizService.getQuizModificationObservable().subscribe(() => this.updateQuizzes());
    }

    ngOnInit(): void {
        this.updateQuizzes();
    }

    ngOnDestroy(): void {
        this.quizSubscription?.unsubscribe();
    }

    canToggleVisibility(quiz: Quiz): boolean {
        return quiz.owner === this.userService.user.username;
    }

    updateQuizzes(): void {
        this.quizzes = this.quizService.getAllQuiz().slice().reverse();
    }

    truncateText(text: string, limit: number = 20): string {
        if (!text) return 'N/A';
        return text.length > limit ? text.substring(0, limit) + '...' : text;
    }
    
    deleteQuiz(quiz: Quiz): void {
        this.quizService.removeQuiz(quiz.id);
    }

    toggleVisibility(quiz: Quiz): void {
        this.quizService.toggleVisibility(quiz.id);
    }

    visibility(quiz: Quiz): string {
        return quiz.isPublic ? 'visibility' : 'visibility_off';
    }

    modifyQuiz(quiz: Quiz): void {
        this.quizValidationService.setQuizToModify(quiz);
    }

    createNewQuiz(): void {
        this.quizValidationService.setQuizToModify(null);
        this.router.navigate(['/quiz-form']);
    }
}
