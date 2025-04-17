import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { TranslateService } from '@ngx-translate/core';
import { ConfirmationModalComponent } from '@app/components/modal/confirmation-modal/confirmation-modal.component';
@Component({
    selector: 'app-login-page',
    templateUrl: './login-page.component.html',
    styleUrls: ['./login-page.component.scss'],
})
export class LoginPageComponent implements OnInit {
    error = '';
    form = { username: '', password: '' };
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

    login() {
        if (!this.form.username.trim()) {
            this.error = 'AccountValidation.RequiredUsername';
            return;
        }

        if (!this.form.password.trim()) {
            this.error = 'AccountValidation.RequiredPassword';
            return;
        }

        this.userAuthService.attemptAuthentication(this.form.username, this.form.password).subscribe({
            next: async () => this.router.navigate(['/home']),
            error: (response) => this.error = this.translate.instant(response.error.error)
        });
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
