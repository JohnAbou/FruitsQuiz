import { Service } from 'typedi';
import { Question } from '@common/interfaces/question';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { QUESTION_COLLECTION, QUIZ_COLLECTION } from '@app/consts/database.consts';
import { Quiz } from '@common/interfaces/quiz';

@Service()
export class QuestionImageService {
  private questionDataManager: DataManagerService<Question>;
  private quizDataManager: DataManagerService<Quiz>;

  constructor(dataManagerService: DataManagerService<Question>, quizDataManager: DataManagerService<Quiz>) {
    this.questionDataManager = dataManagerService;
    this.questionDataManager.setCollection(QUESTION_COLLECTION);
    
    this.quizDataManager = quizDataManager;
    this.quizDataManager.setCollection(QUIZ_COLLECTION);
  }

  async findQuestionsWithSameImageId(imageId: string): Promise<Question[]> {
    const standaloneQuestions = await this.questionDataManager.findElements({ imageId });
    
    const quizzes = await this.quizDataManager.getElements();
    const questionsInQuizzes: Question[] = [];
    
    for (const quiz of quizzes) {
      if (quiz.questions) {
        const matchingQuestions = quiz.questions.filter(question => question.imageId === imageId);
        questionsInQuizzes.push(...matchingQuestions);
      }
    }
    
    return [...standaloneQuestions, ...questionsInQuizzes];
  }
}
