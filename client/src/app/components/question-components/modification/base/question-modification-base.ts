import { Directive } from '@angular/core';
import { InputValidity } from '@app/interfaces/input-validity';
import { QuestionValidationService } from '@app/services/question-services/question-validation.service';
import { QuestionService } from '@app/services/question-services/question.service';
import { Question } from '@common/interfaces/question';
import { QuestionType } from '@common/enums/question-type';

@Directive()
export abstract class QuestionModificationBase {
    showMessage: boolean = false;
    abstract question: Question;
    protected showValidation: boolean = false;


    constructor(
        protected questionValidationService: QuestionValidationService,
        protected questionService: QuestionService,
    ) {}

    get questionPointsValidity(): InputValidity {
        return this.questionValidationService.validateQuestionPoints(this.question.points);
    }

    get nameValidity(): InputValidity {
        return this.questionValidationService.validateName(this.question.text);
    }

    get estimationsValidity(): InputValidity {
        return this.questionValidationService.validateEstimation(this.question.type === QuestionType.QRE ? this.question.estimations : null);
    }


    addToQuestionBank(): void {
        this.question.lastModification = new Date();
        this.showValidation = true;
        const submissionSuccess = this.questionValidationService.attemptQuestionSubmit(this.question);
        this.showMessage = submissionSuccess;
    }
}
