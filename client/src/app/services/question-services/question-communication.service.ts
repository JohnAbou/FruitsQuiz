import { HttpClient, HttpHeaders } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { Question } from '@common/interfaces/question';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { DataSocketEvent } from '@common/enums/socket-event/data-socket-event';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';
import { UserAuthenticationService } from '../user-authentication.service';

@Injectable({
    providedIn: 'root',
})
export class QuestionCommunicationService {
    httpOptions = {
        headers: new HttpHeaders({ contentType: 'application/json' }),
    };
    questionsUpdatedEvent: EventEmitter<void> = new EventEmitter<void>();

    private readonly questionUrl: string = `${environment.serverUrl}/question`;

    private socketService: SocketService;

    constructor(
        private http: HttpClient,
        private readonly authService: UserAuthenticationService,
        readonly socketFactoryService: SocketFactoryService,
    ) {
        this.socketService = socketFactoryService.getSocket();
        this.setupSocket();
    }

    getQuestions(): Observable<Question[]> {
        return this.http.get<Question[]>(this.questionUrl);
    }

    getQuestion(id: string): Observable<Question> {
        const url = `${this.questionUrl}/${id}`;
        return this.http.get<Question>(url);
    }

    addQuestion(question: Question) {
        return this.http.post<Question>(this.questionUrl, question, {
            headers: this.authService.getSessionIdHeaders(),
            observe: 'response',
            responseType: 'json',
        });
    }

    deleteQuestion(id: string): Observable<Question> {
        const url = `${this.questionUrl}/${id}`;
        return this.http.delete<Question>(url, this.httpOptions);
    }

    updateQuestion(question: Question): Observable<Question> {
        return this.http.put<Question>(this.questionUrl, question, this.httpOptions);
    }

    private setupSocket() {
        this.socketService.on(DataSocketEvent.QuestionChangedNotification, () => this.onQuestionNotification());
    }

    private onQuestionNotification() {
        this.questionsUpdatedEvent.emit();
    }
}
