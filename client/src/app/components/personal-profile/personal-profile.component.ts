import { Component, OnInit, OnDestroy } from '@angular/core';
import { UserExperienceInfo } from '@common/interfaces/user-experience';
import { UserInfoService } from '@app/services/user-info.service';
import { UserLevelService } from '@app/services/user-level.service';
import { PreferencesService } from '@app/services/preferences.service';
import { UserStatsService } from '@app/services/user-stats.service';
import { UserStats } from '@app/interfaces/user-stats';
import { Subscription } from 'rxjs';
import { formatTime } from '@app/utils/format-time';
import { take } from 'rxjs/operators';


@Component({
    selector: 'app-personal-profile',
    templateUrl: './personal-profile.component.html',
    styleUrls: ['./personal-profile.component.scss'],
})

export class PersonalProfileComponent implements OnInit, OnDestroy {
    level: UserExperienceInfo | null = null;

    progression = 0;
    modal = false;
    public previousUsername: string = '';
    newUsername: string = '';
    public usernameError: string = '';
    nextLevel = 0;

    userStats: UserStats | null = null;

    get user() {
        return this.userInfoService.userObservable;
    }

    subscriptions: Subscription[] = [];

    constructor(
        private userInfoService: UserInfoService,
        private userLevel: UserLevelService,
        public themeService: PreferencesService,
        private statsService: UserStatsService,
    ) { }

    ngOnInit(): void {
        this.subscriptions.push(this.userLevel.getUserExpInfo().subscribe((expData) => {
            this.level = expData;
            this.nextLevelForXP();
            this.progressionBar();
        }));

        this.subscriptions.push(this.statsService.getUserStats(this.userInfoService.user.id)
            .subscribe((stats) => this.userStats = stats));
    }

    ngOnDestroy(): void {
        this.subscriptions.forEach((subscription) => subscription.unsubscribe());
    }

    usernameModify() {
        this.modal = true;
        this.userInfoService.userObservable.pipe(take(1)).subscribe(user => {
          this.previousUsername = user.username;
          this.newUsername = user.username;
        });
      }
    
    changeTheme(theme: string) {
        this.themeService.setTheme(theme);
    }

    saveUsername() {
        this.usernameError = '';
        
        if (this.newUsername === this.previousUsername) {
            this.modal = false;
            return;
        }

        this.userInfoService.updateUsername(this.newUsername).subscribe({
            next: (response) => {
                if (response.success) {
                    this.modal = false;
                } else {
                    this.usernameError = response.error || 'AccountValidation.unknownError';
                }
            },
            error: () => {
                this.usernameError = 'AccountValidation.updateError';
            }
        });
    }

      cancelUsernameEdit() {
        this.newUsername = this.previousUsername;
        this.usernameError = '';
        this.modal = false;
      }


    progressionBar(): void {
        if (this.level && this.level.experience !== undefined && this.level.expToNextLevel !== undefined) {
            // it is just to even out the percentage in order to use the angular material for the progression bar
            // eslint-disable-next-line @typescript-eslint/no-magic-numbers
            this.level.experience = Math.ceil(this.level.experience);
            this.level.expToNextLevel = Math.ceil(this.level.expToNextLevel);
            this.progression = (this.level.experience + 1) / (this.level.experience + this.level.expToNextLevel)* 100;
        } else {
            this.progression = 0;
        }
    }

    nextLevelForXP(): void {
        if (this.level) {
            this.level.experience = Math.ceil(this.level?.experience);
            this.nextLevel = Math.ceil(this.level.experience + this.level.expToNextLevel);
        }
    }

    formatTime(time: number): string {
        return formatTime(time);
    }

    cropEmail(email: string): string {
        return email.length <= 30 ? email : email.slice(0, 27) + '...';
    }
}
