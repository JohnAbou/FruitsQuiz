import { Service } from 'typedi';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { Quiz } from '@common/interfaces/quiz';
import { CommonDataControllerService } from './common-data.controller';
import { QUIZ_COLLECTION } from '@app/consts/database.consts';
import { DataModifiedSocket } from '@app/services/sockets/data-modified-socket.service';
import { Response } from 'express';
import { getUserMiddleware, RequestWithUser } from '@app/middlewares/user-required-middleware';
import { StatusCodes } from 'http-status-codes';
import { QuizReviewDataManager } from '@app/services/data/quiz-review-data-manager.service';
import { QuizReview } from '@app/interfaces/quiz-review';
import { ImageService } from '@app/services/image/image.service';
import { QuestionImageService } from '@app/services/image/question-image.service';
import { UsernameModificationService } from '@app/services/users/username-modification.service';

@Service()
export class QuizController extends CommonDataControllerService<Quiz> {
    constructor(
        quizDataManager: DataManagerService<Quiz>,
        private dataModifiedSocket: DataModifiedSocket,
        private quizReviewDataManager: QuizReviewDataManager,
        private imageService: ImageService,
        private imageReferenceService: QuestionImageService,
        usernameModificationService: UsernameModificationService,
    ) {
        super(quizDataManager, QUIZ_COLLECTION);
        usernameModificationService.usernameModifiedEvent.subscribe((event) => this.handleUsernameModified(event));
    }

    protected onElementModification() {
        this.dataModifiedSocket.emitQuizChangedNotification();
    }

    protected configureRouter(): void {
        this.router.get('/', getUserMiddleware, this.getQuizzes.bind(this));
        this.router.get('/:id', getUserMiddleware, this.validateOwnerShip(this.getElementById.bind(this)));
        this.router.post('/', getUserMiddleware, this.addQuiz.bind(this));
        this.router.put('/:id', getUserMiddleware, this.validateOwnerShip(this.attemptModification.bind(this)));
        this.router.delete('/:id', getUserMiddleware, this.validateOwnerShip(this.deleteQuizCascade.bind(this)));
        this.router.post('/:id/reviews', getUserMiddleware, this.postQuizReview.bind(this));
        this.router.get('/:id/reviews', getUserMiddleware, this.getQuizReviewsInfo.bind(this));
        this.router.get('/:id/reviews/me', getUserMiddleware, this.getUserQuizReview.bind(this));
    }

    private async getQuizzes(request: RequestWithUser, response: Response) {
        try {
            const user = request.user;
            const quizzes = await this.dataManagerService.getElements();
            const filteredQuizzes = quizzes.filter((quiz: Quiz) => quiz.isPublic || quiz.owner === user.username);
            response.json(filteredQuizzes);
        } catch (reason) {
            this.handleError(response, reason as string);
        }
    }

    private async addQuiz(request: RequestWithUser, response: Response) {
        try {
            const user = request.user;
            const quiz = request.body;
            if (quiz.id !== '0') {
                return this.attemptModification(request, response);
            }
            request.body.owner = user.username;
            return this.addElement(request, response);
        } catch (reason) {
            return this.handleError(response, reason as string);
        }
    }


    private async getUserQuizReview(request: RequestWithUser, response: Response) {
        try {
            const quizId = request.params.id;
            const quizReview = await this.quizReviewDataManager.getReview(quizId, request.user.username);

            return response.status(StatusCodes.OK).json(quizReview);
        } catch (reason) {
            return this.handleError(response, reason as string);
        }
    }

    private async postQuizReview(request: RequestWithUser, response: Response) {
        try {
            const quizReview: QuizReview = request.body;
            quizReview.username = request.user.username;

            const result = await this.quizReviewDataManager.postReview(quizReview);
            this.dataModifiedSocket.emitQuizReviewsInfoChangedNotification(quizReview.quizId);

            return response.status(result ? StatusCodes.CREATED : StatusCodes.BAD_REQUEST).send();
        } catch (reason) {
            return this.handleError(response, reason as string);
        }
    }

    private async getQuizReviewsInfo(request: RequestWithUser, response: Response) {
        try {
            const quizId = request.params.id;
            const quizReviewsInfo = await this.quizReviewDataManager.getQuizReviewsInfo(quizId);
            response.json(quizReviewsInfo);
        } catch (reason) {
            return this.handleError(response, reason as string);
        }
    }

    private validateOwnerShip(action: (request: RequestWithUser, response: Response) => Promise<void>) {
        return async (request: RequestWithUser, response: Response) => {
            try {
                const id = request.params.id;
                if (!this.validateArgumentId(response, id)) return;

                const quiz = await this.dataManagerService.getElementById(id);

                if (!quiz) {
                    return response.status(StatusCodes.NOT_FOUND).send();
                } else if (!quiz.isPublic && quiz.owner !== request.user.username) {
                    return response.status(StatusCodes.FORBIDDEN).send();
                } else {
                    return action(request, response);
                }
            } catch (reason) {
                return this.handleError(response, reason as string);
            }
        };
    }

    private async attemptModification(request: RequestWithUser, response: Response) {
        try {
            const user = request.user;
            const newQuiz = request.body;

            const oldQuiz = await this.dataManagerService.getElementById(newQuiz.id);
            if (oldQuiz.isPublic !== newQuiz.isPublic && oldQuiz.owner !== user.username) return response.status(StatusCodes.FORBIDDEN).send();

            return this.replaceElement(request, response);
        } catch (reason) {
            return this.handleError(response, reason as string);
        }
    }

    private async deleteQuizCascade(request: RequestWithUser, response: Response) {
        try {
            const quizId = request.params.id;
            const quiz = await this.dataManagerService.getElementById(quizId);
            if (!quiz) {
                return response.status(StatusCodes.NOT_FOUND).send();
            }

            const imageIds = quiz.questions
                .filter(question => question.imageId)
                .map(question => question.imageId);

            await this.dataManagerService.deleteElement(quizId);

            await Promise.all(
                imageIds.map(async (imageId) => {
                    const questionsWithSameImage = await this.imageReferenceService.findQuestionsWithSameImageId(imageId);
                    if (questionsWithSameImage.length === 0) {
                        try {
                            await this.imageService.deleteImage(imageId);
                        } catch (err) {
                            console.error(`Error deleting image with ID ${imageId}:`, err);
                        }
                    }
                })
            );

            this.onElementModification();
            return response
                .status(StatusCodes.OK)
                .json({ message: "Quiz and associated images deleted successfully." });
        } catch (reason) {
            return this.handleError(response, reason as string);
        }
    }

    // This isnt the proper place to handle the event but whatever it works
    private async handleUsernameModified(event: { newUsername: string; oldUsername: string; }) {
        await this.dataManagerService.updateElements({ owner: event.oldUsername }, { owner: event.newUsername });
        await this.quizReviewDataManager.updateElements({ username: event.oldUsername }, { username: event.newUsername });

        this.onElementModification();
    }

}
