import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PreferencesService } from '@app/services/preferences.service';

@Component({
    selector: 'app-initial-view-page',
    templateUrl: './initial-view-page.component.html',
    styleUrls: ['./initial-view-page.component.scss'],
})
export class InitialViewPageComponent implements OnInit {
    constructor(
        private router: Router,
        private themeService: PreferencesService,
    ) {}

    ngOnInit() {
        this.updateLogo();
        this.themeService.themeChanges$.subscribe(() => {
            this.updateLogo();
        });
    }


    openJoinGameModal(): void {
        this.router.navigate(['/game-joining']);
    }

    openAdminLoginModal(): void {
        this.router.navigate(['/admin']);
    }

    updateLogo() {
        const logoElement = document.getElementById('theme-logo') as HTMLImageElement;
        if (logoElement) {
            const logoUrl = getComputedStyle(document.body)
                .getPropertyValue('--logo-url')
                .trim()
                .replace(/(^"|"$)/g, '');
            logoElement.src = logoUrl.replace(/^url\(["']?/, '').replace(/["']?\)$/, '');
        }
    }
}
