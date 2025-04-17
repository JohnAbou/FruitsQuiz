import { Service } from 'typedi';
import { Question } from '@common/interfaces/question';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { CommonDataControllerService } from './common-data.controller';
import { QUESTION_COLLECTION } from '@app/consts/database.consts';
import { DataModifiedSocket } from '@app/services/sockets/data-modified-socket.service';
import { QuestionImageService } from '@app/services/image/question-image.service';
import { ImageService } from '@app/services/image/image.service';
import { StatusCodes } from 'http-status-codes';
import { Request, Response } from 'express';
import { getUserMiddleware, RequestWithUser } from '@app/middlewares/user-required-middleware';
@Service()
export class QuestionController extends CommonDataControllerService<Question> {
    constructor(
        dataManagerService: DataManagerService<Question>,
        private dataModified: DataModifiedSocket,
        private imageReferenceService: QuestionImageService,
        private imageService: ImageService,
    ) {
        super(dataManagerService, QUESTION_COLLECTION);
    }

    protected onElementModification() {
        this.dataModified.emitQuestionChangedNotification();
    }

    protected configureRouter(): void {
        this.router.get('/', this.getAllElements.bind(this));
        this.router.get('/:id', this.getElementById.bind(this));
        this.router.post('/', getUserMiddleware, this.addQuestion.bind(this));
        this.router.put('/', this.replaceElement.bind(this));
        this.router.delete('/:id', this.deleteQuestion.bind(this));
    }

    async addQuestion(request: RequestWithUser, response: Response): Promise<void> {
        const question = request.body;
        const username = request.user.username;

        question.author = username;
        await this.addElement(request, response);
    }

    async deleteQuestion(request: Request, response: Response): Promise<void> {
        await this.attemptOperation(response, async () => {
            const id = request.params.id;
            const question = await this.dataManagerService.getElementById(id);
            if (!question) {
                response.status(StatusCodes.NOT_FOUND).send();
                return;
            }
            
            await this.dataManagerService.deleteElement(id);
            
            if (question.imageId) {
                const questionsWithSameImage = await this.imageReferenceService.findQuestionsWithSameImageId(question.imageId);
                if (questionsWithSameImage.length === 0) {
                    try {
                        await this.imageService.deleteImage(question.imageId);
                    } catch (err) {
                        // Silently handle image deletion errors 
                    }
                }
            }
            this.onElementModification();
            response.status(StatusCodes.NO_CONTENT).send();
        });
    }
}
