import { Service } from 'typedi';
import { DataManagerService } from './data-manager.service';
import { DataBaseAcces } from './database-acces.service';
import { QUIZ_REVIEW_COLLECTION } from '@app/consts/database.consts';
import { QuizReviewsInfo } from '@common/interfaces/quiz-review-info';
import { QuizReview } from '@app/interfaces/quiz-review';

@Service({ transient: true })
export class QuizReviewDataManager extends DataManagerService<QuizReview> {
    constructor(dbAcces: DataBaseAcces) {
        super(dbAcces);
        this.setCollection(QUIZ_REVIEW_COLLECTION);
    }

    async postReview(review: QuizReview): Promise<boolean> {
        const existingReview = await this.getCollection().findOne({ quizId: review.quizId, username: review.username });
        if (!existingReview)
            return await this.addElementNoCheck(review);

        review.id = existingReview.id;
        return await this.replaceElement(review);
    }

    async getReview(quizId: string, username: string): Promise<QuizReview> {
        const review = await this.getCollection().findOne({ quizId, username });
        return review as unknown as QuizReview;
    }

    async getQuizReviewsInfo(quizId: string): Promise<QuizReviewsInfo> {
        const collection = this.getCollection();
        const reviews = await collection.find({ quizId }).toArray();

        const reviewCount = reviews.length;
        const averageScore = reviewCount > 0
            ? reviews.reduce((sum, review) => sum + review.score, 0) / reviewCount
            : 0;

        return { averageScore, quizId, reviewCount };
    }
}
