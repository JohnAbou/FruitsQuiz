import { Component, Input, OnInit } from '@angular/core';
import { QuizReview } from '@app/interfaces/quiz-review';
import { QuizReviewsService } from '@app/services/quiz-services/quiz-reviews.service';


@Component({
	selector: 'app-quiz-send-rating',
	templateUrl: './quiz-send-rating.component.html',
	styleUrls: ['./quiz-send-rating.component.scss']
})
export class QuizSendRatingComponent implements OnInit {
	@Input() quizId: string;

	score: number = 0;
	hearts: number[] = [1, 2, 3, 4, 5];
	hasReviewed: boolean = false;

	constructor(private quizReviewsService: QuizReviewsService) { }

	ngOnInit() {
		let subscription = this.quizReviewsService.getQuizReview(this.quizId).subscribe((review) => {
			this.updateRating(review);
			subscription.unsubscribe();
		});
	}

	rateQuiz(value: number) {
		this.score = value;
		this.hasReviewed = true;
		this.quizReviewsService.addQuizReview(this.quizId, {
			score: this.score,
			quizId: this.quizId,
		});
	}

	private updateRating(review: QuizReview | null) {
		if (!review) return;
		this.hasReviewed = true;
		this.score = review.score;
	}
}
