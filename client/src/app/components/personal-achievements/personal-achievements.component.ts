import { Component, OnInit } from '@angular/core';
import { UserStats } from '@app/interfaces/user-stats';
import { UserStatsService } from '@app/services/user-stats.service';

@Component({
  selector: 'app-personal-achievements',
  templateUrl: './personal-achievements.component.html',
  styleUrls: ['./personal-achievements.component.scss']
})
export class PersonalAchievementsComponent implements OnInit {
  stats: UserStats | null = null;
  constructor(private readonly userStats: UserStatsService){}

  ngOnInit(): void {
    this.userStats.getUserPersonalStats().subscribe((statsData) => {
      this.stats = statsData;
    });
  }
}
