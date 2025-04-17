import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { QuizReviewsInfo } from '@common/interfaces/quiz-review-info';

import { QuizCommunicationService } from './quiz-communication.service';
import { SocketService } from '../socket-service/socket.service';
import { SocketFactoryService } from '../socket-service/socket-factory.service';
import { DataSocketEvent } from '@common/enums/socket-event/data-socket-event';
import { QuizReview } from '@app/interfaces/quiz-review';

@Injectable({
    providedIn: 'root',
})
export class QuizReviewsService {
    private socketService: SocketService;
    
    constructor(
        private readonly quizCommunicationService: QuizCommunicationService,
        readonly socketFactoryService: SocketFactoryService,
    ) {
        this.socketService = this.socketFactoryService.getSocket();
    }

    getQuizReviewsInfo(quizId: string): Observable<QuizReviewsInfo> {
        return this.quizCommunicationService.getQuizReviewsInfo(quizId);
    }

    addQuizReview(quizId: string, review: QuizReview) {
        return this.quizCommunicationService.addQuizReview(quizId, review);
    }

    getQuizReview(quizId: string): Observable<QuizReview | null> {
        return this.quizCommunicationService.getQuizReview(quizId);
    }

    onQuizReviewUpdated(quizId: string, callback: () => void) {
        this.socketService.on(
            `${DataSocketEvent.QuizReviewsInfoChangedNotification}-${quizId}`,
            callback
        );
    }

    offQuizReviewUpdated(quizId: string, callback: () => void) {
        this.socketService.off(
            `${DataSocketEvent.QuizReviewsInfoChangedNotification}-${quizId}`,
            callback
        );
    }
}
