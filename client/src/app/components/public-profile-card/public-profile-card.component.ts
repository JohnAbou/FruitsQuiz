import { Component, Inject, Input, OnChanges, OnInit, Optional, SimpleChanges } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { User } from '@app/interfaces/user';
import { UserStats } from '@app/interfaces/user-stats';
import { UserExperienceInfo } from '@common/interfaces/user-experience';
import { UserStatsService } from '@app/services/user-stats.service';
import { UsersService } from '@app/services/users.service';
import { UserLevelService } from '@app/services/user-level.service';
import { getAvatarSource } from '@app/utils/avatar';
import { Observable, Subscription } from 'rxjs';

@Component({
  selector: 'app-public-profile-card',
  templateUrl: './public-profile-card.component.html',
  styleUrls: ['./public-profile-card.component.scss']
})
export class PublicProfileCardComponent implements OnChanges, OnInit {
  @Input() userId: string = '';

  userObservable?: Observable<User | null>;
  levelObservable: Observable<UserExperienceInfo>;
  statsObservable: Observable<UserStats>;
  formattedEXP = 0;

  private subscription: Subscription;

  constructor(
    @Optional() @Inject(MAT_DIALOG_DATA) public data: { userId: string } | null,
    @Optional() public dialogRef: MatDialogRef<PublicProfileCardComponent> | null,
    private readonly usersService: UsersService,
    private readonly userStatsService: UserStatsService,
    private readonly userLevelService: UserLevelService,
  ) { }


  ngOnInit(): void {
    this.init();
  }

  ngOnChanges(changes: SimpleChanges): void {
    this.init();
  }

  ngOnDestroy(): void {
    this.subscription?.unsubscribe();
  }

  getSource(avatarId: string) {
    return getAvatarSource(avatarId);
  }

  close(): void {
    if (this.dialogRef) {
      this.dialogRef.close();
    }
  }

  private init() {
    let id = this.userId;
    if (!id && this.data) {
      id = this.data.userId;
    }

    if (id) {
      this.userObservable = this.usersService.getUserInfo(id);
      this.statsObservable = this.userStatsService.getUserStats(id);
      this.levelObservable = this.userLevelService.getUserExpInfoById(id);

      this.subscription = this.levelObservable.subscribe((xp) => {
        this.formattedEXP = Math.ceil(xp.experience ?? 0);
      });
    }
  }
}
