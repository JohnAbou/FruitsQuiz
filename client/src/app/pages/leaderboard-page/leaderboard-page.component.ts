import { Component, OnDestroy, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { UserWithStats } from '@app/interfaces/user-stats';
import { UserStatsService } from '@app/services/user-stats.service';
import { AvatarModifiedEvent, UsernameModifiedEvent, UsersService } from '@app/services/users.service';
import { getAvatarSource } from '@app/utils/avatar';
import { formatTime } from '@app/utils/format-time';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-leaderboard-page',
  templateUrl: './leaderboard-page.component.html',
  styleUrls: ['./leaderboard-page.component.scss']
})
export class LeaderboardPageComponent implements OnInit, OnDestroy, AfterViewInit {
  leaderboard: UserWithStats[] = [];
  dataSource = new MatTableDataSource<any>([]);

  displayedColumns: string[] = [
    'rank',
    'username',
    'totalGameWon',
    'totalGameTime',
    'bestWinStreak',
    'currentWinStreak',
    'totalPoints',
    'coinGained',
    'coinSpent'
  ];

  @ViewChild(MatSort) sort: MatSort;

  private subscription: Subscription = new Subscription();
  private dataLoaded = false;

  constructor(
    private readonly statsService: UserStatsService,
    private readonly usersService: UsersService,
  ) { }

  ngOnInit() {
    this.subscription.add(
      this.statsService.getUsersStats()
        .subscribe((data) => {
          this.leaderboard = data.filter((user) => user.userStats);
          this.updateData();
        })
    );

    this.subscription.add(
      this.usersService.usernameModifiedEvent.subscribe(this.onUsernameModified.bind(this))
    );

    this.subscription.add(
      this.usersService.avatarModifiedEvent.subscribe(this.onAvatarModified.bind(this))
    );
  }

  ngAfterViewInit() {
    if (this.dataLoaded) {
      this.dataSource.sort = this.sort;
    }

    this.dataSource.sortingDataAccessor = (item, property) => {
      return -1 * item[property];
    };
  }

  ngOnDestroy(): void {
    this.subscription?.unsubscribe();
  }

  formatGameTime(seconds: number): string {
    return formatTime(seconds);
  }

  getAvatarUrl(avatarId: string): string {
    return getAvatarSource(avatarId);
  }

  private onUsernameModified(event: UsernameModifiedEvent) {
    this.leaderboard = this.leaderboard.map((userWithStats) => {
      if (userWithStats.username !== event.oldUsername) return userWithStats;
      userWithStats.username = event.newUsername;
      return userWithStats;
    });
    this.updateData();
  }

  private onAvatarModified(event: AvatarModifiedEvent) {
    this.leaderboard = this.leaderboard.map((userWithStats) => {
      if (userWithStats.username !== event.username) return userWithStats;
      userWithStats.activeAvatarId = event.newAvatar;
      return userWithStats;
    });
    this.updateData();
  }

  private updateData() {
    const mappedData = this.leaderboard
      .sort((a, b) => b.userStats.totalGameWon - a.userStats.totalGameWon)
      .map(user => ({
        id: user.id,
        username: user.username,
        activeAvatarId: user.activeAvatarId,
        totalPoints: user.userStats.totalPoints,
        totalSurvivedQuestion: user.userStats.totalSurvivedQuestion,
        totalGameTime: user.userStats.totalGameTime,
        totalGameWon: user.userStats.totalGameWon,
        currentWinStreak: user.userStats.currentWinStreak,
        bestWinStreak: user.userStats.bestWinStreak,
        coinSpent: user.userStats.coinSpent,
        coinGained: user.userStats.coinGained
      }));

    this.dataSource.data = mappedData;

    if (this.sort) {
      this.dataSource.sort = this.sort;
    }
  }
}