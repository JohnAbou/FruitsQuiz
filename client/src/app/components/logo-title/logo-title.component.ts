import { Component, OnInit, AfterViewInit } from '@angular/core';
import { PreferencesService } from '@app/services/preferences.service';

@Component({
    selector: 'app-logo-title',
    templateUrl: './logo-title.component.html',
    styleUrls: ['./logo-title.component.scss'],
})
export class LogoTitleComponent implements OnInit, AfterViewInit {
    logoUrl: string = '';
    siteName: string = 'FRUITS QUIZ';

    constructor(private themeService: PreferencesService) {}

    ngOnInit() {
        this.themeService.themeChanges$.subscribe(() => {
            this.updateThemeProperties();
        });
    }

    ngAfterViewInit() {
        this.updateThemeProperties();
    }

    updateThemeProperties() {
        const computedStyle = getComputedStyle(document.body);
        this.logoUrl = computedStyle.getPropertyValue('--logo-url')
            .trim()
            .replace(/url\(["']?/, '')
            .replace(/["']?\)/, '');
        this.siteName = computedStyle.getPropertyValue('--site-name')
            .trim()
            .replace(/(^"|"$)/g, '');
    }
}
