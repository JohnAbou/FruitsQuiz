import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { GameChallengeService } from '@app/services/game-services/game-challenge.service';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { GameStateService } from '@app/services/game-services/game-state.service';
import { UserGameRole } from '@common/enums/user-game-role';
@Component({
    selector: 'app-results-view',
    templateUrl: './results-view.component.html',
    styleUrls: ['./results-view.component.scss'],
})
export class ResultsViewComponent {
    currentSlide = 0;
    private slideCount = 0;

    get gameType() {
        return this.gameInfoService.getGameType();
    }

    get gameRole() {
        return this.gameRoleService.getRoleObservable();
    }

    get challengeCode() {
        return this.gameChallengeService.challenge.code;
    }

    get slides() {
        return Array.from({ length: this.slideCount }, (_, i) => i);
    }

    constructor(
        private readonly gameInfoService: GameInfoService,
        private readonly gameRoleService: GameStateService,
        private readonly gameChallengeService: GameChallengeService,
        private readonly router: Router,
    ) {
        this.slideCount = 2;
        if (this.gameRoleService.getCurrentRole() !== UserGameRole.Organizer) this.slideCount += 2;
        if (this.challengeCode !== 0) this.slideCount += 1;
    }

    previousSlide() {
        this.currentSlide = this.currentSlide > 0 ? this.currentSlide - 1 : this.slides.length - 1;
    }

    nextSlide() {
        this.currentSlide = this.currentSlide < this.slides.length - 1 ? this.currentSlide + 1 : 0;
    }

    goToSlide(index: number) {
        this.currentSlide = index;
    }

    quit() {
		this.router.navigate(['/home']);
	}
}
