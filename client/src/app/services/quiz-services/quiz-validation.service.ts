import { Injectable } from '@angular/core';
import { InputValidity } from '@app/interfaces/input-validity';
import { Quiz } from '@common/interfaces/quiz';
import { QuestionValidationService } from '@app/services/question-services/question-validation.service';
import { QuizService } from './quiz.service';
import { MAXIMUM_QUESTION_TIME, MINIMUM_QUESTION_TIME } from '@app/consts/quiz.consts';
import { ValidationBaseService } from '@app/services/validation-services/validation-base.service';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
    providedIn: 'root',
})
export class QuizValidationService extends ValidationBaseService {
    private quizToModify: Quiz | null;
    showValidation: boolean = false;

    constructor(
        private questionValidator: QuestionValidationService,
        private quizService: QuizService,
        private translate: TranslateService
    ) {
        super();
    }

    setQuizToModify(quiz: Quiz | null): void {
        this.quizToModify = quiz;
    }

    getQuizToModify(): Quiz | null {
        return this.quizToModify;
    }

    setShowValidation(show: boolean): void {
        this.showValidation = show;
    }

    validateAnswerTime(answerTime: number): InputValidity {
        if (!this.showValidation) return this.createValidInputValidity();
        
        if (answerTime < MINIMUM_QUESTION_TIME || answerTime > MAXIMUM_QUESTION_TIME)
            return this.createInvalidInputValidity(this.translate.instant('QuizValidationError.InvalidDuration')+'\n');

        return this.createValidInputValidity();
    }

    validateQuizName(name: string, quizTestedId: string): InputValidity {
        if (!this.showValidation) return this.createValidInputValidity();

        const quizWithSameName = this.quizService.getAllQuiz().find((quiz) => quiz.title.trim().toLowerCase() === name.trim().toLowerCase());

        if (quizWithSameName && quizTestedId !== quizWithSameName.id)
            return this.createInvalidInputValidity(this.translate.instant('QuizValidationError.QuizNameAlreadyExists'));
        return this.validateText(name, this.translate.instant('QuizValidationError.QuizNameEmpty'));
    }

    validateQuizDescription(description: string): InputValidity {
        if (!this.showValidation) return this.createValidInputValidity();
        return this.validateText(description, this.translate.instant('QuizValidationError.QuizDescriptionEmpty'));
    }

    validateQuiz(quiz: Quiz): InputValidity {
        let isQuizValid = this.createValidInputValidity();

        isQuizValid = this.modifyInputValidity(isQuizValid, this.validateQuizName(quiz.title, quiz.id));
        isQuizValid = this.modifyInputValidity(isQuizValid, this.validateAnswerTime(quiz.duration));
        isQuizValid = this.modifyInputValidity(isQuizValid, this.validateQuizDescription(quiz.description));

        if (!this.validateQuestions(quiz, isQuizValid))
            isQuizValid = this.modifyInputValidity(isQuizValid, this.createInvalidInputValidity(this.translate.instant('QuizValidationError.QuizInvalidQuestions')+'\n'));

        return isQuizValid;
    }

    attemptSubmit(quiz: Quiz): InputValidity {
        this.showValidation = true;
        const quizValidity = this.validateQuiz(quiz);

        if (!quizValidity.isValid) return quizValidity;

        this.quizService.addQuiz(quiz);
        this.quizToModify = null;
        this.showValidation = false;
        return quizValidity;
    }

    private validateQuestions(quiz: Quiz, isQuizValid: InputValidity): boolean {
        if (quiz.questions.length) return quiz.questions.every((question) => this.questionValidator.validateQuestion(question));
        isQuizValid.errorMessage += this.translate.instant('QuizValidationError.NeedAtLeastOneQuestion') +  '\n';
        isQuizValid.isValid = false;
        return false;
    }
}
