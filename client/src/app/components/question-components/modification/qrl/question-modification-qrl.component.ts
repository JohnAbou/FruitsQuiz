import { Component, Input, OnInit } from '@angular/core';
import { Question } from '@common/interfaces/question';
import { QuestionModificationBase } from '@app/components/question-components/modification/base/question-modification-base';
import { QuestionValidationService } from '@app/services/question-services/question-validation.service';
import { QuestionService } from '@app/services/question-services/question.service';
import { InputValidity } from '@app/interfaces/input-validity';

@Component({
    selector: 'app-question-modification-qrl',
    templateUrl: './question-modification-qrl.component.html',
    styleUrls: ['./question-modification-qrl.component.scss'],
})
export class QuestionModificationQrlComponent extends QuestionModificationBase implements OnInit {
    @Input() question: Question;

    constructor(
        protected questionValidationService: QuestionValidationService,
        protected questionService: QuestionService,
    ) {
        super(questionValidationService, questionService);
    }

    ngOnInit(): void {
        this.question ??= this.questionService.createVoidQRLQuestion();
    }

    get nameValidity(): InputValidity {
        return this.showValidation ? 
            this.questionValidationService.validateName(this.question.text) :
            { isValid: true, errorMessage: '' };
    }

    get questionPointsValidity(): InputValidity {
        return this.showValidation ? 
            this.questionValidationService.validateQuestionPoints(this.question.points) :
            { isValid: true, errorMessage: '' };
    }

    onImageUploaded(newImageId: string, question: Question): void {
        question.imageId = newImageId;
    }

    onImageDeleted(question: Question): void {
        question.imageId = '';
    }
}
