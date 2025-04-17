import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { User } from '@app/interfaces/user';
import { getAvatarSource } from '@app/utils/avatar';
import { MatDialog } from '@angular/material/dialog';
import { PublicProfileCardComponent } from '../public-profile-card/public-profile-card.component';
import { BotPlayer } from '@common/interfaces/bot-player';
import { AvatarNavigationService } from '@app/services/avatar-navigation.service';
import { UserAuthenticationService } from '@app/services/user-authentication.service';

@Component({
    selector: 'app-profile-avatar-icon',
    templateUrl: './profile-avatar-icon.component.html',
    styleUrls: ['./profile-avatar-icon.component.scss'],
})
export class ProfileAvatarIconComponent implements OnInit {
    @Input() user?: User;
    @Input() bot?: BotPlayer;
    @Input() size: string = '40px';

    private initialUser: User;
    private ipcRenderer: any;

    constructor(
        private readonly router: Router,
        private readonly avatarNavigationService: AvatarNavigationService,
        private readonly dialog: MatDialog,
        private authService: UserAuthenticationService,
        
    ) {
        if ((window as any).require) {
            this.ipcRenderer = (window as any).require('electron').ipcRenderer;
        }
    }

    ngOnInit(): void {
        if (this.user) {
            this.initialUser = this.user;
        }

        Object.defineProperty(this, 'user', {
            get: () => this.initialUser,
            set: (value: User) => (this.initialUser = value),
        });
    }

    navigateToProfile(user: User): void {
        if (this.ipcRenderer && !this.authService.isUserAuthenticated()) {
            this.ipcRenderer.send('open-profile-in-main', { userId: user.id });
        }
        else if (this.avatarNavigationService.canNavigateSafely) {
            this.router.navigate(['/real-public-profile', user.id]);
        } 
        else {
            this.openProfileModal(user.id);
        }
    }

    openProfileModal(userId: string): void {
        this.dialog.open(PublicProfileCardComponent, {
            data: { userId: userId },
            panelClass: 'no-padding-dialog',
        });
    }

    getAvatarSource(user: User): string {
        return getAvatarSource(user.activeAvatarId ?? '');
    }

    getBotAvatarSource(bot: BotPlayer): string {
        const filename = `${bot.difficulty.toLocaleLowerCase()}_${bot.avatarType}.png`;
        return `./assets/bot-avatars/${filename}`;
    }
}
