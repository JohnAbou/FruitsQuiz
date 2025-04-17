import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { QuestionService } from '@app/services/question-services/question.service';
import { Question } from '@common/interfaces/question';
import { QuestionType } from '@common/enums/question-type';

interface QuestionBankModalData {
    selectedQuestions: string[];
}

type QuestionTypeFilter = QuestionType | 'ALL';

interface QuestionTypeOption {
    value: QuestionTypeFilter;
    label: string;
}

@Component({
    selector: 'app-question-bank-modal',
    templateUrl: './question-bank-modal.component.html',
    styleUrls: ['./question-bank-modal.component.scss'],
})
export class QuestionBankModalComponent {
    questions: Question[] = [];
    selectedQuestions: Set<string> = new Set();
    searchTerm: string = '';
    selectedType: QuestionTypeFilter = 'ALL';

    readonly questionTypes: QuestionTypeOption[] = [
        { value: 'ALL', label: 'All Types' },
        { value: QuestionType.QCM, label: 'Multiple Choice' },
        { value: QuestionType.QRL, label: 'Long Answer' },
        { value: QuestionType.QRE, label: 'Estimation' },
    ];

    constructor(
        private dialogRef: MatDialogRef<QuestionBankModalComponent>,
        private questionService: QuestionService,
        @Inject(MAT_DIALOG_DATA) private data: QuestionBankModalData,
    ) {
        this.questions = this.questionService.getQuestions();
        this.selectedQuestions = new Set(data.selectedQuestions);
    }

    get filteredQuestions(): Question[] {
        return this.questions.filter((question) => {
            const matchesSearch = question.text.toLowerCase().includes(this.searchTerm.toLowerCase());
            const matchesType = this.selectedType === 'ALL' || question.type === this.selectedType;
            return matchesSearch && matchesType;
        });
    }

    toggleQuestionSelection(questionId: string): void {
        if (this.selectedQuestions.has(questionId)) {
            this.selectedQuestions.delete(questionId);
        } else {
            this.selectedQuestions.add(questionId);
        }
    }

    isQuestionSelected(questionId: string): boolean {
        return this.selectedQuestions.has(questionId);
    }

    isQuestionInUse(questionId: string): boolean {
        return this.data.selectedQuestions.includes(questionId);
    }

    getQuestionTypeIcon(type: QuestionTypeFilter): string {
        if (type === 'ALL') return 'list';
        switch (type) {
            case QuestionType.QCM:
                return 'check_box';
            case QuestionType.QRL:
                return 'subject';
            case QuestionType.QRE:
                return 'calculate';
            default:
                return 'help';
        }
    }

    onCancel(): void {
        this.dialogRef.close();
    }

    onConfirm(): void {
        const selectedQuestions = this.questions.filter(q => 
            this.selectedQuestions.has(q.id) && !this.isQuestionInUse(q.id)
        );
        this.dialogRef.close(selectedQuestions);
    }
} 