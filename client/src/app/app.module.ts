import { HTTP_INTERCEPTORS, HttpClient, HttpClientModule } from '@angular/common/http';
import { CUSTOM_ELEMENTS_SCHEMA, NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatListModule } from '@angular/material/list';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from '@app/modules/app-routing.module';
import { AppMaterialModule } from '@app/modules/material.module';
import { AppComponent } from '@app/pages/app/app.component';
import { InitialViewPageComponent } from '@app/pages/initial-view-page/initial-view-page.component';
import { ChatComponent } from './components/chat/chat.component';
import { GameCountdownComponent } from './components/game-components/game-countdown/game-countdown.component';
import { LocalQuestionBankComponent } from './components/local-question-bank/local-question-bank.component';
import { LogoTitleComponent } from './components/logo-title/logo-title.component';
import { ConfirmationModalComponent } from './components/modal/confirmation-modal/confirmation-modal.component';
import { InformationModalComponent } from './components/modal/information-modal/information-modal.component';
import { QuestionFormComponent } from './components/question-components/question-form/question-form.component';
import { QuestionModificationQCMComponent } from './components/question-components/modification/qcm/question-modification-qcm.component';
import { QuestionsComponent } from './components/question-components/questions/questions.component';
import { QuizDetailsComponent } from './components/quiz-components/quiz-details/quiz-details.component';
import { QuizHeaderComponent } from './components/quiz-components/quiz-header/quiz-header.component';
import { AdminViewComponent } from './pages/admin-view/admin-view.component';
import { GameCreationPageComponent } from './pages/game-creation-page/game-creation-page.component';
import { GameParentPageComponent } from './pages/game-parent-page/game-parent-page.component';
import { QuestionBankComponent } from './pages/question-bank/question-bank.component';
import { QuizCreationPageComponent } from './pages/quiz-creation-page/quiz-creation-page.component';
import { ResultsViewComponent } from './pages/results-view/results-view.component';
import { WaitViewComponent } from './pages/wait-view/wait-view.component';
import { QuizService } from './services/quiz-services/quiz.service';
import { MatTableModule } from '@angular/material/table';
import { MatSortModule } from '@angular/material/sort';
import { QuestionModificationQrlComponent } from './components/question-components/modification/qrl/question-modification-qrl.component';
import { QuestionFilterComponent } from './components/question-components/question-filter/question-filter.component';
import { AnswerQcmComponent } from './components/answer/answer-qcm/answer-qcm.component';
import { AnswerQrlComponent } from './components/answer/answer-qrl/answer-qrl.component';
import { PlayerCorrectionComponent } from './components/correction/player-correction/player-correction.component';
import { OrganizerCorrectionComponent } from './components/correction/organizer-correction/organizer-correction.component';
import { RandomQuizDetailsComponent } from './components/quiz-components/random-quiz-details/random-quiz-details.component';
import { RandomQuizHeaderComponent } from './components/quiz-components/random-quiz-header/random-quiz-header.component';
import { InteractiveTimerComponent } from './components/game-components/interactive-timer/interactive-timer.component';
import { LoginPageComponent } from './pages/login-page/login-page.component';
import { SignupPageComponent } from './pages/signup-page/signup-page.component';
import { ChatMessagesComponent } from './components/chat-messages/chat-messages.component';
import { ChatListComponent } from './components/chat-list/chat-list.component';
import { HeaderComponent } from './components/header/header.component';
import { GameJoiningPageComponent } from './pages/game-joining-page/game-joining-page.component';
import { GameIntermissionViewComponent } from './pages/game-intermission-view/game-intermission-view.component';
import { GameLoadingViewComponent } from './pages/game-loading-view/game-loading-view.component';
import { GameHeaderComponent } from './components/game-components/game-header/game-header.component';
import { GameQuestionInfoHeaderComponent } from './components/game-components/game-question-info-header/game-question-info-header.component';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { TranslateLoader, TranslateModule } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { LanguageInterceptor } from './interceptors/language-interceptor';
import { PublicProfileComponent } from './pages/public-profile/public-profile.component';
import { SidebarComponent } from './components/sidebar-profile/sidebar-profile.component';
import { PersonalProfileComponent } from './components/personal-profile/personal-profile.component';
import { ProfileHeaderComponent } from './components/profile-header/profile-header.component';
import { MatTabsModule } from '@angular/material/tabs';
import { ResultsStatsQuizComponent } from './components/results-components/results-stats-quiz/results-stats-quiz.component';
import { QuizSendRatingComponent } from './components/quiz-components/quiz-send-rating/quiz-send-rating.component';
import { QuizViewRatingComponent } from './components/quiz-components/quiz-view-rating/quiz-view-rating.component';
import { FriendRequestsComponent } from './components/friend-requests/friend-requests.component';
import { NotificationComponent } from './components/notification/notification.component';
import { FriendsListComponent } from './components/friends-list/friends-list.component';
import { GameLobbyHeaderComponent } from './components/game-lobby-header/game-lobby-header.component';
import { TemplateGameViewComponent } from './pages/template-game-view/template-game-view.component';
import { LinePlayerListComponent } from './components/line-player-list/line-player-list.component';
import { GameScoreComponent } from './components/game-components/game-score/game-score.component';
import { GameOrganizerControlComponent } from './components/game-components/game-organizer-control/game-organizer-control.component';
import { GamePlayerListComponent } from './components/game-player-list/game-player-list.component';
import { QuestionModificationQREComponent } from './components/question-components/modification/qre/question-modification-qre.component';
import { AnswerQreComponent } from './components/answer/answer-qre/answer-qre.component';
import { EliminationModalComponent } from './components/modal/elimination-modal/elimination-modal.component';
import { QuizCreationPageDetailsComponent } from './components/quiz-components/quiz-creation-page-details/quiz-creation-page-details.component';
import { QuickJoinComponent } from './components/quick-join/quick-join.component';
import { FloatingTextInputComponent } from './components/resusable-components/floating-text-input/floating-text-input.component';
import { LeaderboardPlayerListComponent } from './components/leaderboard-player-list/leaderboard-player-list.component';
import { ImageEditComponent } from './components/image/image-edit/image-edit.component';
import { ImageViewComponent } from './components/image/image-view/image-view.component';
import { DefaultPageTemplateComponent } from './pages/default-page-template/default-page-template.component';
import { UsersListPageComponent } from './pages/users-list-page/users-list-page.component';
import { PersonalProfileFriendsComponent } from './components/personal-profile-friends/personal-profile-friends.component';
import { RealPublicProfilePageComponent } from './pages/real-public-profile-page/real-public-profile-page.component';
import { FriendRequestControlComponent } from './components/friend-request-control/friend-request-control.component';
import { GameCorrectAnswerQreComponent } from './components/game-components/game-correct-answer-qre/game-correct-answer-qre.component';
import { AvatarModalComponent } from './components/avatar-modal/avatar-modal.component';
import { PreferencesComponent } from './components/preferences/preferences.component';
import { TermsModalComponent } from './components/terms-modal/terms-modal.component';
import { SurvivalQuizHeaderComponent } from './components/quiz-components/survival-quiz-header/survival-quiz-header.component';
import { SurvivalQuizDetailsComponent } from './components/quiz-components/survival-quiz-details/survival-quiz-details.component';
import { SurvivalModeProgressionComponent } from './components/survival-mode-progression/survival-mode-progression.component';
import { SurvivalResultViewComponent } from './components/survival-result-view/survival-result-view.component';
import { QuestionCountSelectionComponent } from './components/quiz-components/question-count-selection/question-count-selection.component';
import { PersonalProfileContentComponent } from './components/personal-profile-content/personal-profile-content.component';
import { FriendRequestControlLineComponent } from './components/friend-request-control-line/friend-request-control-line.component';
import { ProfileIconComponent } from './components/profile-icon/profile-icon.component';
import { MatSliderModule } from '@angular/material/slider';
import { ResultWinnerComponent } from './components/results-components/result-winner/result-winner.component';
import { HistoryPageComponent } from './pages/history-page/history-page.component';
import { GameResultsComponent } from './components/game-components/game-results/game-results.component';
import { GameWinStreakComponent } from './components/game-components/game-win-streak/game-win-streak.component';
import { GameMetricsComponent } from './components/game-components/game-metrics/game-metrics.component';
import { LeaderboardPageComponent } from './pages/leaderboard-page/leaderboard-page.component';
import { ShopPageComponent } from './pages/shop-page/shop-page.component';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { ProfileAvatarIconComponent } from './components/profile-avatar-icon/profile-avatar-icon.component';
import { GameBuyHintComponent } from './components/game-components/game-buy-hint/game-buy-hint.component';
import { ChallengePresentationComponent } from './components/game-components/challenge-presentation/challenge-presentation.component';
import { PublicProfileCardComponent } from './components/public-profile-card/public-profile-card.component';
import { LockedItemDialogComponent } from './components/locked-item-dialog/locked-item-dialog';
import { TranslatedDatePipe } from './pipes/translated-date.pipe';
import { registerLocaleData } from '@angular/common';
import localeFr from '@angular/common/locales/fr';
import localeEn from '@angular/common/locales/en';
import { CreateChatComponent } from './components/chat-create/chat-create.component';
import { JoinChatComponent } from './components/chat-join/chat-join.component';
import { PersonalAchievementsComponent } from './components/personal-achievements/personal-achievements.component';
import { GameLootsComponent } from './components/game-components/game-loots/game-loots.component';
import { UserBalanceComponent } from './components/user-balance/user-balance.component';
import { SurvivalBestScoreComponent } from './components/survival-best-score/survival-best-score.component';
import { QuizViewRatingLineComponent } from './components/quiz-components/quiz-view-rating-line/quiz-view-rating-line.component';
import { LeaderboardCarouselComponent } from './components/leaderboard_carousel/leaderboard-carousel.component';
import { AchievementsContainerComponent } from './components/achievements-container/achievements-container.component';
import { QuestionBankModalComponent } from './components/modal/question-bank-modal/question-bank-modal.component';
import { MatIconModule } from '@angular/material/icon';
import { WaitPagePlayerListComponent } from './components/wait-page-player-list/wait-page-player-list.component';

export function HttpLoaderFactory(http: HttpClient) {
    return new TranslateHttpLoader(http, './assets/localization/', '.json');
}

/**
 * Main module that is used in main.ts.
 * All automatically generated components will appear in this module.
 * Please do not move this module in the module folder.
 * Otherwise Angular Cli will not know in which module to put new component
 */

registerLocaleData(localeFr, 'fr');
registerLocaleData(localeEn, 'en');
@NgModule({
    declarations: [
        AppComponent,
        InitialViewPageComponent,
        GameCreationPageComponent,
        QuizHeaderComponent,
        LogoTitleComponent,
        QuizDetailsComponent,
        InformationModalComponent,
        QuestionsComponent,
        QuestionBankComponent,
        QuestionFormComponent,
        QuizCreationPageComponent,
        QuestionModificationQCMComponent,
        AdminViewComponent,
        LocalQuestionBankComponent,
        ResultsViewComponent,
        ChatComponent,
        ChatMessagesComponent,
        ChatListComponent,
        ShopPageComponent,
        WaitViewComponent,
        ConfirmationModalComponent,
        GameParentPageComponent,
        GameCountdownComponent,
        AnswerQcmComponent,
        AnswerQrlComponent,
        PlayerCorrectionComponent,
        OrganizerCorrectionComponent,
        QuestionModificationQrlComponent,
        QuestionFilterComponent,
        RandomQuizDetailsComponent,
        RandomQuizHeaderComponent,
        InteractiveTimerComponent,
        LoginPageComponent,
        SignupPageComponent,
        HeaderComponent,
        GameJoiningPageComponent,
        JoinChatComponent,
        GameIntermissionViewComponent,
        GameLoadingViewComponent,
        GameHeaderComponent,
        GameQuestionInfoHeaderComponent,
        PublicProfileComponent,
        SidebarComponent,
        PersonalProfileComponent,
        ProfileHeaderComponent,
        LockedItemDialogComponent,
        ResultsStatsQuizComponent,
        QuizSendRatingComponent,
        QuizViewRatingComponent,
        FriendRequestsComponent,
        NotificationComponent,
        FriendsListComponent,
        GameLobbyHeaderComponent,
        TemplateGameViewComponent,
        LinePlayerListComponent,
        GameScoreComponent,
        GameOrganizerControlComponent,
        GamePlayerListComponent,
        QuestionModificationQREComponent,
        AnswerQreComponent,
        EliminationModalComponent,
        QuizCreationPageDetailsComponent,
        QuickJoinComponent,
        FloatingTextInputComponent,
        LeaderboardPlayerListComponent,
        ImageEditComponent,
        ImageViewComponent,
        DefaultPageTemplateComponent,
        UsersListPageComponent,
        PersonalProfileFriendsComponent,
        RealPublicProfilePageComponent,
        FriendRequestControlComponent,
        AvatarModalComponent,
        GameCorrectAnswerQreComponent,
        PreferencesComponent,
        TermsModalComponent,
        SurvivalQuizHeaderComponent,
        SurvivalQuizDetailsComponent,
        HistoryPageComponent,
        SurvivalModeProgressionComponent,
        SurvivalResultViewComponent,
        QuestionCountSelectionComponent,
        PersonalProfileContentComponent,
        FriendRequestControlLineComponent,
        ProfileIconComponent,
        ResultWinnerComponent,
        GameResultsComponent,
        GameWinStreakComponent,
        GameMetricsComponent,
        LeaderboardPageComponent,
        ProfileAvatarIconComponent,
        GameBuyHintComponent,
        ChallengePresentationComponent,
        PublicProfileCardComponent,
        TranslatedDatePipe,
        GameLootsComponent,
        CreateChatComponent,
        PersonalAchievementsComponent,
        UserBalanceComponent,
        SurvivalBestScoreComponent,
        QuizViewRatingLineComponent,
        LeaderboardCarouselComponent,
        AchievementsContainerComponent,
        QuestionBankModalComponent,
        WaitPagePlayerListComponent,
    ],
    imports: [
        AppMaterialModule,
        AppRoutingModule,
        MatSliderModule,
        MatSelectModule,
        BrowserAnimationsModule,
        BrowserModule,
        FormsModule,
        HttpClientModule,
        MatButtonModule,
        MatListModule,
        MatProgressSpinnerModule,
        ReactiveFormsModule,
        MatFormFieldModule,
        MatInputModule,
        MatSelectModule,
        MatDialogModule,
        MatSnackBarModule,
        MatCardModule,
        MatTableModule,
        MatSortModule,
        MatProgressBarModule,
        MatSlideToggleModule,
        MatButtonToggleModule,
        MatTabsModule,
        MatIconModule,
        TranslateModule.forRoot({
            loader: {
                provide: TranslateLoader,
                useFactory: HttpLoaderFactory,
                deps: [HttpClient],
            },
        }),
    ],
    providers: [
        QuizService,
        {
            provide: HTTP_INTERCEPTORS,
            useClass: LanguageInterceptor,
            multi: true,
        },
    ],
    bootstrap: [AppComponent],
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class AppModule {}
