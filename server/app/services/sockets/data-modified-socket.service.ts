import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { DataSocketEvent } from '@common/enums/socket-event/data-socket-event';
import { GameInfo } from '@common/interfaces/game-info';

@Service()
export class DataModifiedSocket extends BaseSocketHandler {
    emitQuestionChangedNotification() {
        this.socketManager.emit(DataSocketEvent.QuestionChangedNotification);
    }

    emitQuizChangedNotification() {
        this.socketManager.emit(DataSocketEvent.QuizChangedNotification);
    }

    emitQuizReviewsInfoChangedNotification(quizId: string) {
        this.socketManager.emit(`${DataSocketEvent.QuizReviewsInfoChangedNotification}-${quizId}`);
    }

    emitGameInfoChangedNotification(infos: GameInfo[]) {
        this.socketManager.emit(DataSocketEvent.GameInfoChangedNotification, infos);
    }

    emitChatUsernameChangedNotification() {
        this.socketManager.emit(DataSocketEvent.ChatUsernameChangedNotification);
    }
}
