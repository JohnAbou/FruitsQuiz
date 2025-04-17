import { HttpClient, HttpResponse } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { Quiz } from '@common/interfaces/quiz';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';
import { DataSocketEvent } from '@common/enums/socket-event/data-socket-event';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { QuizReviewsInfo } from '@common/interfaces/quiz-review-info';
import { QuizReview } from '@app/interfaces/quiz-review';

@Injectable({
    providedIn: 'root',
})
export class QuizCommunicationService {
    quizModifiedEvent: EventEmitter<void> = new EventEmitter<void>();

    private readonly baseUrl: string = environment.serverUrl;
    private socketService: SocketService;

    constructor(
        private readonly http: HttpClient,
        private readonly authService: UserAuthenticationService,
        readonly socketFactoryService: SocketFactoryService,
    ) {
        this.socketService = socketFactoryService.getSocket();
        this.setupSocket();

        this.authService.connectionEvent.subscribe(() => this.quizModifiedEvent.emit());
    }

    getQuizzes(): Observable<Quiz[]> {
        return this.http.get<Quiz[]>(`${this.baseUrl}/quiz`, { headers: this.authService.getSessionIdHeaders() });
    }

    addQuiz(quiz: Quiz): Observable<HttpResponse<string>> {
        return this.http.post(`${this.baseUrl}/quiz`, quiz, {
            headers: this.authService.getSessionIdHeaders(),
            observe: 'response',
            responseType: 'text',
        });
    }

    removeQuiz(quizId: string): Observable<HttpResponse<string>> {
        return this.http.delete(`${this.baseUrl}/quiz/${quizId}`, {
            headers: this.authService.getSessionIdHeaders(),
            observe: 'response',
            responseType: 'text',
        });
    }

    updateQuiz(quiz: Quiz): Observable<HttpResponse<string>> {
        return this.http.put(`${this.baseUrl}/quiz/${quiz.id}`, quiz, {
            headers: this.authService.getSessionIdHeaders(),
            observe: 'response',
            responseType: 'text',
        });
    }

    getQuizReviewsInfo(quizId: string): Observable<QuizReviewsInfo> {
        return this.http.get<QuizReviewsInfo>(`${this.baseUrl}/quiz/${quizId}/reviews`, {
            headers: this.authService.getSessionIdHeaders(),
        });
    }

    getQuizReview(quizId: string): Observable<QuizReview> {
        return this.http.get<QuizReview>(`${this.baseUrl}/quiz/${quizId}/reviews/me`, {
            headers: this.authService.getSessionIdHeaders(),
        });
    }

    addQuizReview(quizId: string, review: QuizReview) {
        return this.http.post<QuizReview>(`${this.baseUrl}/quiz/${quizId}/reviews`, review, {
            headers: this.authService.getSessionIdHeaders(),
        }).subscribe();
    }

    private setupSocket() {
        this.socketService.on(DataSocketEvent.QuizChangedNotification, () => this.onQuizNotification());
    }

    private onQuizNotification() {
        this.quizModifiedEvent.emit();
    }
}
