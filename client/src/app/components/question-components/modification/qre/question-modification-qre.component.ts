import { Component, Input, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { Subject } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import { Question } from '@common/interfaces/question';
import { QuestionModificationBase } from '@app/components/question-components/modification/base/question-modification-base';
import { QuestionValidationService } from '@app/services/question-services/question-validation.service';
import { QuestionService } from '@app/services/question-services/question.service';
import { InputValidity } from '@app/interfaces/input-validity';

@Component({
  selector: 'app-question-modification-qre',
  templateUrl: './question-modification-qre.component.html',
  styleUrls: ['./question-modification-qre.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class QuestionModificationQREComponent extends QuestionModificationBase implements OnInit {
  @Input() question: Question;
  toleranceOptions: { floor: number; ceil: number; step: number };
  private boundsChangeSubject = new Subject<void>();

  constructor(
    protected questionValidationService: QuestionValidationService,
    protected questionService: QuestionService,
    protected cdr: ChangeDetectorRef
  ) {
    super(questionValidationService, questionService);
  }

  ngOnInit(): void {
    this.question ??= this.questionService.createVoidQREQuestion();
    this.initializeToleranceOptions();
    this.boundsChangeSubject.pipe(debounceTime(100)).subscribe(() => {
      this.initializeToleranceOptions();
      this.cdr.markForCheck();
    });
  }

  onBoundsChange(): void {
    this.boundsChangeSubject.next();
  }

  onLowerBoundChange(): void {
    this.onBoundsChange();
  }

  onUpperBoundChange(): void {
    this.onBoundsChange();
  }

  onToleranceChange(value: number): void {
    this.question.estimations!.toleranceMargin = value;
    this.cdr.markForCheck();
  }

  onExactValueChange(): void {
    const exact = Number(this.question.estimations!.exactValue) || 0;
    const lower = Number(this.question.estimations!.lowerBound);
    const upper = Number(this.question.estimations!.upperBound);
    
    
    if (!isNaN(upper) && upper < exact) {
      this.question.estimations!.upperBound = exact;
    }
    
    if (this.question.estimations!.lowerBound === null || this.question.estimations!.lowerBound === undefined || isNaN(lower)) {
      this.question.estimations!.lowerBound = exact;
    }
    
    if (this.question.estimations!.upperBound === null || this.question.estimations!.upperBound === undefined || isNaN(upper)) {
      this.question.estimations!.upperBound = exact;
    }
    
    this.initializeToleranceOptions();
    this.cdr.markForCheck();
  }
  

  addToQuestionBank(): void {
    super.addToQuestionBank();
  }

  private initializeToleranceOptions(): void {
    if (!this.question.estimations) return;
    
    const lowerBound = Number(this.question.estimations.lowerBound) || 0;
    const upperBound = Number(this.question.estimations.upperBound) || 100;
    const range = upperBound - lowerBound;
    
    this.toleranceOptions = {
      floor: 0,
      ceil: Math.max(Math.floor(range / 4), 1), 
      step: 1
    };
    
    if (this.question.estimations.toleranceMargin > this.toleranceOptions.ceil) {
      this.question.estimations.toleranceMargin = this.toleranceOptions.ceil;
    }
    if (this.question.estimations.toleranceMargin < this.toleranceOptions.floor) {
      this.question.estimations.toleranceMargin = this.toleranceOptions.floor;
    }
  }

  onImageUploaded(newImageId: string, question: Question): void {
    question.imageId = newImageId;
  }

  onImageDeleted(question: Question): void {
    question.imageId = '';
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

  get estimationsValidity(): InputValidity {
    return this.showValidation ? 
        this.questionValidationService.validateEstimation(this.question.estimations) :
        { isValid: true, errorMessage: '' };
  }
}
