import { Service } from 'typedi';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { Question } from '@common/interfaces/question';
import { QUESTION_COLLECTION } from '@app/consts/database.consts';
import { Quiz } from '@common/interfaces/quiz';
import { QuestionType } from '@common/enums/question-type';

@Service()
export class SpecialQuizService {
    constructor(private dataManagerService: DataManagerService<Question>) {
        dataManagerService.setCollection(QUESTION_COLLECTION);
    }

    async createSpecialQuiz(questionNumber: number): Promise<Quiz> {
        return {
            id: '0',
            title: 'system-special-quiz',
            description: '',
            questions: await this.getRandomQuestions(questionNumber),
            duration: 20,
            lastModification: new Date(),
            isPublic: true,
            owner: 'system',
        };
    }

    async getRandomQuestions(questionNumber?: number) {
        const questions = (await this.dataManagerService.getElements()).filter((question) =>
            question.type === QuestionType.QCM || question.type === QuestionType.QRE
        );
        questionNumber ??= questions.length;

        const shuffled = questions.sort(() => 0.5 - Math.random());
        return shuffled.slice(0, questionNumber);
    }
}
