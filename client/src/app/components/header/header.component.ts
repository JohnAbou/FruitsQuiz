import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { filter, map } from 'rxjs/operators';
import { MatDialog } from '@angular/material/dialog';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { ConfirmationModalComponent } from '@app/components/modal/confirmation-modal/confirmation-modal.component';
import { TranslateService } from '@ngx-translate/core';
import { UserInfoService } from '@app/services/user-info.service';
import { getAvatarSource } from '@app/utils/avatar';
import { ElementRef, HostListener, ViewChild } from '@angular/core';

declare global {
    interface Window {
      require: any;
    }
  }

@Component({
    selector: 'app-header',
    templateUrl: './header.component.html',
    styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
    isElectron = false;
    showHeader = true;
    profilePanelOpen = false;
    gameMenuOpen = false;
    @ViewChild('gameMenuRef') gameMenuRef!: ElementRef;
    @ViewChild('profileMenuRef') profileMenuRef!: ElementRef;


    constructor(
        private router: Router,
        private userAuthService: UserAuthenticationService,
        private dialog: MatDialog,
        private translate: TranslateService,
        private userInfo:UserInfoService
    ) {}

    get user() {
        return this.userInfo.userObservable;
    }

    get avatarUrl() {
            return this.userInfo.userObservable
                .pipe(map(user => getAvatarSource(user.activeAvatarId)));
    }

    ngOnInit(): void {
        this.router.events.pipe(filter((event): event is NavigationEnd => event instanceof NavigationEnd));
        this.detectElectron();
    }

    logout(): void {
        const message = this.translate.instant('LogoutButtonComponenent.ConfirmLogout');

        const dialogRef = this.dialog.open(ConfirmationModalComponent, { data: message, autoFocus: false });
        dialogRef.afterClosed().subscribe((result: boolean) => {
            if (result) {
                this.userAuthService.logOut();
                this.router.navigate(['/login']);
            }
        });
    }

    toggleProfilePanel() {
        this.profilePanelOpen = !this.profilePanelOpen;
    }

    toggleGameMenu() {
        this.gameMenuOpen = !this.gameMenuOpen;
    }

    @HostListener('document:click', ['$event'])
    onDocumentClick(event: MouseEvent): void {
        const clickedInsideGameMenu = this.gameMenuRef?.nativeElement.contains(event.target);
        const clickedInsideProfile = this.profileMenuRef?.nativeElement.contains(event.target);

        if (!clickedInsideGameMenu) {
            this.gameMenuOpen = false;
        }

        if (!clickedInsideProfile) {
            this.profilePanelOpen = false;
        }
    }

    detectElectron() {
        this.isElectron = !!(window && window.process && window.process.versions && window.process.versions.electron);
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
      

}
