import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AccountResponse } from '@common/interfaces/response/account-response';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { validateConfirmPassword, validateEmail, validatePassword, validateUsername, validateAvatar } from '@app/utils/account-validation';
import { TranslateService } from '@ngx-translate/core';
import { getAvatarSource } from '@app/utils/avatar';
import { ConfirmationModalComponent } from '@app/components/modal/confirmation-modal/confirmation-modal.component';
import { MatDialog } from '@angular/material/dialog';


@Component({
    selector: 'app-signup-page',
    templateUrl: './signup-page.component.html',
    styleUrls: ['./signup-page.component.scss'],
})
export class SignupPageComponent implements OnInit {
    errors = { username: '', password: '', email: '', confirmPassword: '', avatar: '' };
    form = { username: '', password: '', email: '', confirmPassword: '', avatar:'' };
    userAvatars: string[] = Array.from({ length: 12 }, (_, i) => `avatar${i + 1}`);
    selectedAvatar: string | null = null;

    isElectron = false;


    constructor(
        private router: Router,
        private userAuthService: UserAuthenticationService,
        private translate: TranslateService,
        private dialog: MatDialog

    ) {}

    ngOnInit(): void {
        this.detectElectron();
    }

    signup() {
        this.errors.username = validateUsername(this.form.username, this.translate);
        this.errors.email = validateEmail(this.form.email, this.translate);
        this.errors.password = validatePassword(this.form.password, this.translate);
        this.errors.confirmPassword = validateConfirmPassword(this.form.password, this.form.confirmPassword, this.translate);
        this.errors.avatar = validateAvatar(this.form.avatar, this.translate);

        if (this.errors.username || this.errors.email || this.errors.password || this.errors.confirmPassword || this.errors.avatar) return;

        this.userAuthService.attemptCreation(this.form.username, this.form.email, this.form.password, this.form.avatar).subscribe({
            next: async () => this.router.navigate(['/home']),
            error: (response) => this.handleServerError(response.error),
        });
    }

    private handleServerError(response: AccountResponse) {
        this.errors.username = response.usernameError ? this.translate.instant(response.usernameError) : '';
        this.errors.email = response.emailError ? this.translate.instant(response.emailError) : '';
        this.errors.password = response.passwordError ? this.translate.instant(response.passwordError) : '';
    }

    getSource(avatarId: string) {
        return getAvatarSource(avatarId);
    }

    selectAvatar(avatar: string) {
        this.selectedAvatar = avatar;
        this.form.avatar = avatar;
    }

    closeApp(): void {
        const message = this.translate.instant('QuitButtonComponent.ConfirmQuit');
      
        const dialogRef = this.dialog.open(ConfirmationModalComponent, {
          data: message,
          autoFocus: false,
        });
      
        dialogRef.afterClosed().subscribe((result: boolean) => {
          if (result && this.isElectron) {
            const { ipcRenderer } = window.require('electron');
            ipcRenderer.send('quit-app');
          }
        });
    }
    detectElectron() {
        this.isElectron = !!(window && window.process && window.process.versions && window.process.versions.electron);
      }

}
