import { Component } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { ROUND_SORT_FUNCTION, SCORE_SORT_FUNCTION } from '@app/services/game-services/game-players-stat.service';
import { GameType } from '@common/enums/game-type';

@Component({
  selector: 'app-leaderboard-player-list',
  templateUrl: './leaderboard-player-list.component.html',
  styleUrls: ['./leaderboard-player-list.component.scss']
})
export class LeaderboardPlayerListComponent {
  get isClassicalGame() {
    return this.gameInfo.getGameType() === GameType.NormalGame;
  }

  get sortFunction() {
    return this.isClassicalGame ? SCORE_SORT_FUNCTION : ROUND_SORT_FUNCTION;
  }

  constructor(private readonly gameInfo: GameInfoService) { }
}
