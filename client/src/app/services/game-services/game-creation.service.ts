import { Injectable } from '@angular/core';
import { GameBaseService } from './base-classes/game-base.service';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GameType } from '@common/enums/game-type';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { GameStateService } from './game-state.service';
import { UserGameState } from '@common/enums/user-game-state';
import { UserAuthenticationService } from '../user-authentication.service';
import { Quiz } from '@common/interfaces/quiz';
import { QuestionService } from '../question-services/question.service';
import { QuestionType } from '@common/enums/question-type';
import { CurrencyService } from '../currency.service';
import { TranslateService } from '@ngx-translate/core';
import { DialogModalService } from '../dialog-modal.service';

@Injectable({
    providedIn: 'root',
})
export class GameCreationService extends GameBaseService {
    isFriendsOnly = false;
    selectedQuiz: Quiz | null = null;
    entryFee = 0;

    isRandomQuizSelected: boolean = false;
    isSurvivalQuizSelected: boolean = false;

    questionCount = 5;

    constructor(
        socketFactory: SocketFactoryService,
        questionService: QuestionService,
        private gameStateService: GameStateService,
        private userAuthService: UserAuthenticationService,
        private currencyService: CurrencyService,
        private dialog: DialogModalService,
        private translate: TranslateService,
    ) {
        super(socketFactory);
        questionService.questionsObservable.subscribe(
            (questions) => this.questionCount = Math.min(Math.max(questions.filter(
                (question) => question.type === QuestionType.QCM || question.type === QuestionType.QRE
            ).length, 5), this.questionCount)
        );
    }

    createGame(quizId: string, gameType: GameType): boolean {
        if (this.entryFee > this.currencyService.currency && gameType === GameType.EliminationGame) {
            this.dialog.openSnackBar(this.translate.instant("GameCreation.NotEnoughCurrency"));
            return false;
        }

        this.gameStateService.setState(UserGameState.AttemptingToJoin);
        const sessionId = this.userAuthService.getSessionId();

        const socketEventName = gameType === GameType.SurvivalGame ? GameManagementSocketEvent.CreateGameSurvival : GameManagementSocketEvent.CreateGameLobby;
        this.socketService.emit(socketEventName, { quizId, sessionId, isFriendsOnly: this.isFriendsOnly, questionCount: this.questionCount, entryFee: this.entryFee });
        return true;
    }
}
