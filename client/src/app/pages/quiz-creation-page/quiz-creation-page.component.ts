import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { InformationModalComponent } from '@app/components/modal/information-modal/information-modal.component';
import { QuestionBankModalComponent } from '@app/components/modal/question-bank-modal/question-bank-modal.component';
import { VOID_QUIZ } from '@app/consts/quiz.consts';
import { InputValidity } from '@app/interfaces/input-validity';
import { ArrayHelperService } from '@app/services/array-helper.service';
import { QuestionService } from '@app/services/question-services/question.service';
import { QuizValidationService } from '@app/services/quiz-services/quiz-validation.service';
import { UserInfoService } from '@app/services/user-info.service';
import { Question } from '@common/interfaces/question';
import { Quiz } from '@common/interfaces/quiz';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-quiz-creation-page',
    templateUrl: './quiz-creation-page.component.html',
    styleUrls: ['./quiz-creation-page.component.scss'],
})
export class QuizCreationPageComponent implements OnInit {
    isCreating: boolean;
    quiz: Quiz;
    selectedQuestionIndex: number = 0;

    constructor(
        public quizValidationService: QuizValidationService,
        private questionService: QuestionService,
        private arrayHelper: ArrayHelperService,
        private dialog: MatDialog,
        private router: Router,
        private userService: UserInfoService,
        private translate: TranslateService,
    ) {}

    get isVisibilityDisabled(): boolean {
        return !this.isCreating && this.quiz.owner !== this.userService.user.username;
    }

    get title(): string {
        return this.isCreating
            ? this.translate.instant('QuizCreation.CreateQuiz')
            : this.translate.instant('QuizCreation.ModifyQuiz');
    }

    get quizDurationValidity(): InputValidity {
        return this.quizValidationService.validateAnswerTime(this.quiz.duration);
    }

    get nameValidity(): InputValidity {
        return this.quizValidationService.validateQuizName(this.quiz.title, this.quiz.id);
    }

    get quizDescriptioneValidity(): InputValidity {
        return this.quizValidationService.validateQuizDescription(this.quiz.description);
    }

    ngOnInit(): void {
        this.initializeQuiz();
    }

    selectQuestion(index: number): void {
        if (index >= 0 && index < this.quiz.questions.length) {
            this.selectedQuestionIndex = index;
        }
    }

    navigateQuestion(step: number): void {
        const newIndex = this.selectedQuestionIndex + step;
        if (newIndex >= 0 && newIndex < this.quiz.questions.length) {
            this.selectedQuestionIndex = newIndex;
        }
    }

    addQuestionsToQuiz(selectedQuestions: Question[]): void {
        selectedQuestions.forEach((questionToAdd) => {
            if (this.quiz.questions.find((question) => question.id === questionToAdd.id)) return;
            this.quiz.questions.push(questionToAdd);
        });
    }

    addQCMQuestion(): void {
        const newQuestion = this.copyObject(this.questionService.createVoidQCMQuestion());
        this.quiz.questions.push(newQuestion);
        this.selectedQuestionIndex = this.quiz.questions.length - 1;
    }

    addQRLQuestion(): void {
        const newQRLQuestion: Question = this.copyObject(this.questionService.createVoidQRLQuestion());
        this.quiz.questions.push(newQRLQuestion);
        this.selectedQuestionIndex = this.quiz.questions.length - 1;
    }

    addQREQuestion(): void {
        const newQREQuestion: Question = this.copyObject(this.questionService.createVoidQREQuestion());
        this.quiz.questions.push(newQREQuestion);
        this.selectedQuestionIndex = this.quiz.questions.length - 1;
    }

    moveQuestion(index: number, step: number): void {
        this.arrayHelper.swapElement(this.quiz.questions, index, index + step);
    }

    deleteQuestion(index: number): void {
        this.arrayHelper.deleteElement(this.quiz.questions, index);
        if (this.selectedQuestionIndex >= this.quiz.questions.length) {
            this.selectedQuestionIndex = Math.max(0, this.quiz.questions.length - 1);
        }
    }

    submitQuiz(): void {
        this.quiz.lastModification = new Date();
        const isQuizValid = this.quizValidationService.attemptSubmit(this.quiz);

        if (isQuizValid.isValid) {
            this.router.navigate(['/admin']);
            return;
        }

        this.dialog.open(InformationModalComponent, {
            data: isQuizValid.errorMessage,
        });
    }

    openQuestionBankModal(): void {
        const dialogRef = this.dialog.open(QuestionBankModalComponent, {
            width: '80%',
            height: '80%',
            autoFocus: false,
            data: {
                selectedQuestions: this.quiz.questions.map(q => q.id),
            },
        });

        dialogRef.afterClosed().subscribe((selectedQuestions: Question[]) => {
            if (selectedQuestions) {
                this.addQuestionsToQuiz(selectedQuestions);
            }
        });
    }

    private initializeQuiz(): void {
        const quizFromValidation = this.quizValidationService.getQuizToModify();
        this.isCreating = !quizFromValidation;

        this.quiz = this.copyObject(quizFromValidation || VOID_QUIZ);
        this.quiz.lastModification = new Date(this.quiz.lastModification);

        if (this.isCreating) this.addQCMQuestion();
    }

    private copyObject<ObjectType>(objectToCopy: ObjectType) {
        return JSON.parse(JSON.stringify(objectToCopy));
    }
}
