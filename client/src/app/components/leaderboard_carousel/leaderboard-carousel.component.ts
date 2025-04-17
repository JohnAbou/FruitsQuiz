// leaderboard-carousel.component.ts
import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { UserStatsService } from '@app/services/user-stats.service';
import { UserWithStats } from '@app/interfaces/user-stats';
import { formatTime } from '@app/utils/format-time';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-leaderboard-carousel',
  templateUrl: './leaderboard-carousel.component.html',
  styleUrls: ['./leaderboard-carousel.component.scss']
})
export class LeaderboardCarouselComponent implements OnInit, OnDestroy {
  highlights: string[] = [];
  private subscription: Subscription = new Subscription();
 
  constructor(private readonly statsService: UserStatsService, private readonly translateService: TranslateService) {}
 
  ngOnInit() {
    this.subscription.add(
      this.statsService.getUsersStats().subscribe((users: UserWithStats[]) => {
        this.generateHighlights(users);
      })
    );
  }
 
  ngOnDestroy() {
    this.subscription.unsubscribe();
  }

  private generateHighlights(users: UserWithStats[]) {
    const leaderboard = users.filter(u => u.userStats);
    if (leaderboard.length === 0) {
      this.highlights = [this.translateService.instant('HomeCarousel.NoDataAvailable')];
      return;
    }
   
    const topWins = leaderboard.reduce((prev, curr) =>
      (curr.userStats.totalGameWon > prev.userStats.totalGameWon ? curr : prev)
    );
    const topCoins = leaderboard.reduce((prev, curr) =>
      (curr.userStats.coinSpent > prev.userStats.coinSpent ? curr : prev)
    );
    const topPoints = leaderboard.reduce((prev, curr) =>
      (curr.userStats.totalPoints > prev.userStats.totalPoints ? curr : prev)
    );
    const topQuestions = leaderboard.reduce((prev, curr) =>
      (curr.userStats.bestSurvivalScore > prev.userStats.bestSurvivalScore ? curr : prev)
    );
    const topGameTime = leaderboard.reduce((prev, curr) =>
      (curr.userStats.totalGameTime > prev.userStats.totalGameTime ? curr : prev)
    );
    const topCurrentStreak = leaderboard.reduce((prev, curr) =>
      (curr.userStats.currentWinStreak > prev.userStats.currentWinStreak ? curr : prev)
    );
    const topBestStreak = leaderboard.reduce((prev, curr) =>
      (curr.userStats.bestWinStreak > prev.userStats.bestWinStreak ? curr : prev)
    );
   
    this.highlights = [
      `${topWins.username}: ${this.translateService.instant('HomeCarousel.MostWins')} (${topWins.userStats.totalGameWon})`,
      `${topCoins.username}: ${this.translateService.instant('HomeCarousel.MostCoinsSpent')} (${topCoins.userStats.coinSpent})`,
      `${topPoints.username}: ${this.translateService.instant('HomeCarousel.MostPoints')} (${topPoints.userStats.totalPoints})`,
      `${topQuestions.username}: ${this.translateService.instant('HomeCarousel.BestSurvivalScore')} (${topQuestions.userStats.bestSurvivalScore})`,
      `${topGameTime.username}: ${this.translateService.instant('HomeCarousel.LongestGameTime')} (${formatTime(topGameTime.userStats.totalGameTime)})`,
      `${topCurrentStreak.username}: ${this.translateService.instant('HomeCarousel.HighestCurrentWinStreak')} (${topCurrentStreak.userStats.currentWinStreak})`,
      `${topBestStreak.username}: ${this.translateService.instant('HomeCarousel.BestWinStreak')} (${topBestStreak.userStats.bestWinStreak})`
    ];
  }
}
