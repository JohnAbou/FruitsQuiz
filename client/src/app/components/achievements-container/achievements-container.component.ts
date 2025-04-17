import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { UserStats } from '../../interfaces/user-stats';
import { formatTime } from '@app/utils/format-time';

@Component({
  selector: 'app-achievements-container',
  templateUrl: './achievements-container.component.html',
  styleUrls: ['./achievements-container.component.scss']
})
export class AchievementsContainerComponent implements OnChanges {
  @Input() stats: UserStats | null = null;
  formattedGameTime: string = '';

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['stats'] && this.stats) {
      this.formattedGameTime = formatTime(this.stats.totalGameTime);
    }
  }
}
