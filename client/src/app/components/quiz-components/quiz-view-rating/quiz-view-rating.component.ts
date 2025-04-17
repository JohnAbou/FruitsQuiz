import { Component, Input, SimpleChanges } from '@angular/core';
import { QuizReviewsService } from '@app/services/quiz-services/quiz-reviews.service';
import { QuizReviewsInfo } from '@common/interfaces/quiz-review-info';
import { Observable, tap } from 'rxjs';

const EMPTY_REVIEW: QuizReviewsInfo = { averageScore: 0, reviewCount: 0, quizId: '' };

@Component({
    selector: 'app-quiz-view-rating',
    templateUrl: './quiz-view-rating.component.html',
    styleUrls: ['./quiz-view-rating.component.scss'],
})
export class QuizViewRatingComponent {
    @Input() quizId: string;
    @Input() backgroundColor: string = 'white';

    hearts: number[] = [1, 2, 3, 4, 5];
    review: Observable<QuizReviewsInfo>;
    defaultReview: QuizReviewsInfo = EMPTY_REVIEW;

    private reviewUpdateCallback: () => void;

    constructor(private quizReviewsService: QuizReviewsService) {}

    ngOnInit() {
        this.updateReview();
        this.reviewUpdateCallback = () => this.updateReview();
        this.quizReviewsService.onQuizReviewUpdated(this.quizId, this.reviewUpdateCallback);
    }

    ngOnChanges(changes: SimpleChanges) {
        if (!changes.quizId || changes.quizId.isFirstChange()) return;

        this.quizReviewsService.offQuizReviewUpdated(changes.quizId.previousValue, this.reviewUpdateCallback);
        this.updateReview();
        this.quizReviewsService.onQuizReviewUpdated(this.quizId, this.reviewUpdateCallback);
    }

    ngOnDestroy() {
        this.quizReviewsService.offQuizReviewUpdated(this.quizId, this.reviewUpdateCallback);
    }

    private updateReview() {
        this.review = this.quizReviewsService
            .getQuizReviewsInfo(this.quizId)
            .pipe(tap((reviewInfo) => (this.defaultReview = reviewInfo || EMPTY_REVIEW)));
    }
}
