import { Injectable } from '@angular/core';
import { Subject, Observable } from 'rxjs';
import { Quiz } from '@common/interfaces/quiz';
import { QuizCommunicationService } from './quiz-communication.service';

@Injectable({
    providedIn: 'root',
})
export class QuizService {
    private quizzes: Quiz[] = [];
    private quizModificationSubject = new Subject<void>();

    constructor(private readonly quizCommunicationService: QuizCommunicationService) {
        this.quizCommunicationService.quizModifiedEvent.subscribe(() => this.loadQuizzes());
        this.loadQuizzes();
    }

    addQuiz(addedQuiz: Quiz): void {
        this.quizCommunicationService.addQuiz(addedQuiz).subscribe();
    }

    removeQuiz(quizId: string): void {
        if (!this.findQuizById(quizId)) return;
        this.quizCommunicationService.removeQuiz(quizId).subscribe();
    }

    toggleVisibility(quizId: string): void {
        const quizToModify = this.findQuizById(quizId);
        if (!quizToModify) return;

        quizToModify.isPublic = !quizToModify.isPublic;
        this.quizCommunicationService.updateQuiz(quizToModify).subscribe();
    }

    getQuizModificationObservable(): Observable<void> {
        return this.quizModificationSubject.asObservable();
    }

    getAllQuiz(): Quiz[] {
        return this.quizzes;
    }

    private findQuizById(id: string) {
        return this.quizzes.find((quiz) => quiz.id === id);
    }

    private loadQuizzes(): void {
        this.quizCommunicationService.getQuizzes().subscribe((quizzes: Quiz[]) => {
            this.quizzes = quizzes;
            this.quizModificationSubject.next();
        });
    }
}
