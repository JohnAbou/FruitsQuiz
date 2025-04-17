import { Component, Input, OnChanges } from '@angular/core';
import { MAXIMUM_CHARACTER_LONG_ANSWER } from '@app/consts/question.consts';
import { GameAnswerCorrectionService } from '@app/services/game-services/game-answer-correction.service';
import { GameManagerService } from '@app/services/game-services/game-manager.service';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-answer-qrl',
    templateUrl: './answer-qrl.component.html',
    styleUrls: ['./answer-qrl.component.scss'],
})
export class AnswerQrlComponent implements OnChanges {
    @Input() isInteractive = false;

    longAnswer: string;
    maxCharacters: number = MAXIMUM_CHARACTER_LONG_ANSWER;

    get isCorrecting() {
        return this.answerCorrectionService.getIsCorrectingObservable();
    }

    constructor(
        private readonly gameManager: GameManagerService,
        private readonly translateService: TranslateService, 
        private readonly answerCorrectionService: GameAnswerCorrectionService,
    ) {}

    ngOnChanges() {
        this.longAnswer = this.isInteractive ? '' : this.translateService.instant("AnswerQrlComponent.PlayerAnswering");
    }

    canSubmitAnswer() {
        return this.isInteractive && this.gameManager.canSubmitAnswer();
    }

    onTextModified() {
        this.gameManager.updateAnswerResponse(this.longAnswer);
    }
}
