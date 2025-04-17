import { Component } from '@angular/core';
import { GameChallengeService } from '@app/services/game-services/game-challenge.service';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-challenge-presentation',
  templateUrl: './challenge-presentation.component.html',
  styleUrls: ['./challenge-presentation.component.scss']
})
export class ChallengePresentationComponent {

  constructor(
    private readonly gameChallengeService: GameChallengeService,
    private readonly translateService: TranslateService
  ) { }

  get challenge() {
    return this.gameChallengeService.challengeObservable;
  }

  get challengeResult() {
    return this.gameChallengeService.challengeResultObservable;
  }

  getQuestionType(code: number) {
    switch (code) {
      case 4:
        return this.translateService.instant('QuestionType.QCMLong');
      case 5:
        return this.translateService.instant('QuestionType.QRLLong');
      case 6:
        return this.translateService.instant('QuestionType.QRELong');
    }
    return "";
  }
}
