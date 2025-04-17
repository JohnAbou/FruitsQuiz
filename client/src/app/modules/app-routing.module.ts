import { NgModule } from '@angular/core';
import { RouterModule, Routes, mapToCanActivate } from '@angular/router';
import { AdminViewComponent } from '@app/pages/admin-view/admin-view.component';
import { GameCreationPageComponent } from '@app/pages/game-creation-page/game-creation-page.component';
import { GameParentPageComponent } from '@app/pages/game-parent-page/game-parent-page.component';
import { InitialViewPageComponent } from '@app/pages/initial-view-page/initial-view-page.component';
import { QuestionBankComponent } from '@app/pages/question-bank/question-bank.component';
import { QuizCreationPageComponent } from '@app/pages/quiz-creation-page/quiz-creation-page.component';
import { GameAuthGuardService } from '@app/services/auth-guards/game-auth-guard.service';
import { LoginPageComponent } from '@app/pages/login-page/login-page.component';
import { SignupPageComponent } from '@app/pages/signup-page/signup-page.component';
import { AuthenticationAuthGardService } from '@app/services/auth-guards/authentication-auth-guard.service';
import { GameJoiningPageComponent } from '@app/pages/game-joining-page/game-joining-page.component';
import { PublicProfileComponent } from '@app/pages/public-profile/public-profile.component';
import { UsersListPageComponent } from '@app/pages/users-list-page/users-list-page.component';
import { RealPublicProfilePageComponent } from '@app/pages/real-public-profile-page/real-public-profile-page.component';
import { ChatComponent } from '@app/components/chat/chat.component';
import { HistoryPageComponent } from '@app/pages/history-page/history-page.component';
import { LeaderboardPageComponent } from '@app/pages/leaderboard-page/leaderboard-page.component';
import { ShopPageComponent } from '@app/pages/shop-page/shop-page.component';

const routes: Routes = [
    { path: 'home', component: InitialViewPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'shop', component: ShopPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'game-creation', component: GameCreationPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'game-view', component: GameParentPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService, GameAuthGuardService]) },
    { path: 'bank', component: QuestionBankComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    {
        path: 'quiz-form',
        component: QuizCreationPageComponent,
        canActivate: mapToCanActivate([AuthenticationAuthGardService]),
    },
    { path: 'admin', component: AdminViewComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    {
        path: 'user-history',
        component: HistoryPageComponent,
        canActivate: mapToCanActivate([AuthenticationAuthGardService]),
    },
    { path: 'signup', component: SignupPageComponent },
    { path: 'game-joining', component: GameJoiningPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'public-profile', component: PublicProfileComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'chat', component: ChatComponent },
    { path: 'real-public-profile/:id', component: RealPublicProfilePageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'users', component: UsersListPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: 'login', component: LoginPageComponent },
    { path: 'leaderboard', component: LeaderboardPageComponent, canActivate: mapToCanActivate([AuthenticationAuthGardService]) },
    { path: '**', redirectTo: '/home' },
];

@NgModule({
    imports: [RouterModule.forRoot(routes, { useHash: true })],
    exports: [RouterModule],
})
export class AppRoutingModule {}
