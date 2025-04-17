import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { InformationModalComponent } from '@app/components/modal/information-modal/information-modal.component';
import { MAXIMUM_POINT, MINIMUM_POINT, POINT_MULTIPLE } from '@app/consts/question.consts';
import { QuestionType } from '@common/enums/question-type';
import { Choice } from '@common/interfaces/choice';
import { Question } from '@common/interfaces/question';
import { QuestionService } from './question.service';
import { InputValidity } from '@app/interfaces/input-validity';
import { ValidationBaseService } from '@app/services/validation-services/validation-base.service';
import { EMPTY_ID } from '@app/consts/game.consts';
import { Estimations } from '@common/interfaces/question-estimations';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
    providedIn: 'root',
})
export class QuestionValidationService extends ValidationBaseService {
    constructor(
        private questionService: QuestionService,
        private dialog: MatDialog,
        private translate: TranslateService
        
    ) {
        super();
    }

    validateQuestionPoints(points: number): InputValidity {
        if (points < MINIMUM_POINT || points > MAXIMUM_POINT) return this.createInvalidInputValidity(this.translate.instant('QuestionValidationError.PointsRange'));
        if (points % POINT_MULTIPLE) return this.createInvalidInputValidity(this.translate.instant('QuestionValidationError.PointsMultiple'));

        return this.createValidInputValidity();
    }

    validateName(name: string): InputValidity {
        return this.validateText(name, this.translate.instant('GameMessage.EmptyField'));
    }

    validateChoiceText(choiceText: string): InputValidity {
        return this.validateText(choiceText, this.translate.instant('QuestionValidationError.ChoiceTextEmpty'));
    }
    public validateEstimation(estimation: Estimations | null | undefined): InputValidity {
        if (!estimation) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.EstimationDataRequired'));
        }
        if (estimation.exactValue === undefined || estimation.exactValue === null) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.ExactValueRequired'));
        }
        if (estimation.lowerBound === undefined || estimation.lowerBound === null) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.LowerBoundRequired'));
        }
        if (estimation.upperBound === undefined || estimation.upperBound === null) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.UpperBoundRequired'));
        }
        if (estimation.toleranceMargin === undefined || estimation.toleranceMargin === null) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.ToleranceMarginRequired'));
        }
        if (estimation.lowerBound >= estimation.upperBound) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.LowerBoundLessThanUpper'));
        }
        if (estimation.exactValue < estimation.lowerBound || estimation.exactValue > estimation.upperBound) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.ExactValueBetweenBounds'));
        }
        if (estimation.toleranceMargin < 0) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.ToleranceMarginNonNegative'));
        }
        
        const interval = estimation.upperBound - estimation.lowerBound;
        if (estimation.toleranceMargin > interval / 4) {
            return this.createInvalidInputValidity(this.translate.instant('EstimationValidation.ToleranceMarginWithinInterval'));
        }
        
        return this.createValidInputValidity();
    }







    validateResponses(choices: Choice[]): InputValidity {
        const correctChoices = choices.filter((choice) => choice.isCorrect);
        const incorrectChoices = choices.filter((choice) => !choice.isCorrect);

        if (!correctChoices.length || !incorrectChoices.length)
            return this.createInvalidInputValidity(this.translate.instant('QuestionValidationError.AtLeastOneCorrectIncorrect'));

        return this.createValidInputValidity();
    }

    validateQuestion(question: Question): boolean {
        let isQuestionValid = this.validateName(question.text).isValid;
        isQuestionValid &&= this.validateQuestionPoints(question.points).isValid;
        isQuestionValid &&= question.type !== QuestionType.QCM || this.validateQuestionChoices(question.choices);
        isQuestionValid &&= question.type !== QuestionType.QRE || this.validateEstimation(question.estimations).isValid;
        return isQuestionValid;
    }

    attemptQuestionSubmit(question: Question): boolean {
        if (!this.validateQuestion(question)) {
            this.openInformationModal(this.translate.instant('QuestionValidationError.ErrorsRemaining'));
            return false;
        }

        if (question.id !== EMPTY_ID) {
            this.questionService.updateQuestion(question);
            return true;
        }

        if (this.questionService.doesQuestionTextExist(question.text)) {
            this.openInformationModal(this.translate.instant('QuestionValidationError.DuplicateQuestionTitle'));
            return false;
        }

        this.questionService.addQuestion(question);
        return true;
    }
    private openInformationModal(text: string): void {
        this.dialog.open(InformationModalComponent, { data: text });
    }

    private validateQuestionChoices(choices: Choice[]) {
        return choices.every((choice) => this.validateChoiceText(choice.text).isValid) && this.validateResponses(choices).isValid;
    }
}
