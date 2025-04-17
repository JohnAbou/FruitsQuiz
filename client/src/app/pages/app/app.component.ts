import { Component, OnInit } from '@angular/core';
import { GameCountdownService } from '@app/services/game-services/game-countdown.service';
import { GameAnswerCorrectionService } from '@app/services/game-services/game-answer-correction.service';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { GamePlayersStatService } from '@app/services/game-services/game-players-stat.service';
import { GameStateService } from '@app/services/game-services/game-state.service';
import { GameTimerControllerService } from '@app/services/game-services/game-timer-controller.service';
import { GameCorrectionService } from '@app/services/game-services/game-correction.service';
import { TranslateService } from '@ngx-translate/core';
import { FriendsService } from '@app/services/friends.service';
import { ChatService } from '@app/services/chat-services/chat.service';
import { GameEliminationService } from '@app/services/game-services/game-elimination.service';
import { GameCorrectedAnswerService } from '@app/services/game-services/game-corrected-answer.service';
import { UsersService } from '@app/services/users.service';
import { GameResultsService } from '@app/services/game-services/game-results.service';
import { PreferencesService } from '@app/services/preferences.service';
import { CurrencyService } from '@app/services/currency.service';
import { GameChallengeService } from '@app/services/game-services/game-challenge.service';
import { GameLootService } from '@app/services/game-services/game-loot.service';
import { ChatMessageService } from '@app/services/chat-services/chat-message.service';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {
    // All the parameter of this constructor are service that we want to instanciate at the start of the apps
    // The reason is that they listen for socket event, and if we wait for them to be instanciated, when they are needed,
    // we may miss some of these events.
    // eslint-disable-next-line max-params
    constructor(
        readonly gameIntermissionService: GameCountdownService,
        readonly gameManagerService: GameManagerService,
        readonly gameStateService: GameStateService,
        readonly gamePlayersStatService: GamePlayersStatService,
        readonly gameAnswerCorrectionservice: GameAnswerCorrectionService,
        readonly timerControllerService: GameTimerControllerService,
        readonly gameCorrectionMessageService: GameCorrectionService,
        readonly friendRequestsService: FriendsService,
        readonly chatService: ChatService,
        readonly gameEliminationService: GameEliminationService,
        private translate: TranslateService,
        readonly gameCorrectionService: GameCorrectedAnswerService,
        readonly usersService: UsersService,
        readonly gameResultService: GameResultsService,
        readonly preferencesService: PreferencesService,
        readonly currencyService: CurrencyService,
        readonly gameChallengeService: GameChallengeService,
        readonly gameLootService: GameLootService,
        readonly chatMessageService: ChatMessageService,
    ) {
        this.translate.setDefaultLang('en');
        this.preferencesService.loadUserPreferences({} as any);
    }

    ngOnInit() {}
}
