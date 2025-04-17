import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs';
import { environment } from 'src/environments/environment';
import { UserAuthenticationService } from './user-authentication.service';
import { UserPreferences } from '@common/interfaces/response/account-response';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
	providedIn: 'root',
})
export class PreferencesService {
	private defaultTheme: string = 'lemon-theme';
	private defaultBackground: string = 'none';
	public themeSubject = new BehaviorSubject<string>(this.defaultTheme);
	public backgroundSubject = new BehaviorSubject<string>(this.defaultBackground);
	private languageSubject = new BehaviorSubject<string>(this.translateService.currentLang || 'fr');
	
	languageChanges$ = this.languageSubject.asObservable();
	themeChanges$ = this.themeSubject.asObservable();
	backgroundChanges$ = this.backgroundSubject.asObservable();

	constructor(
		private http: HttpClient,
		private authService: UserAuthenticationService,
		private translateService: TranslateService,
	) {
		this.authService.preferencesEvent.subscribe(this.loadUserPreferences.bind(this));
	}

	loadUserPreferences(userPreferences: UserPreferences) {
		this.applyTheme(userPreferences.theme ?? 'lemon-theme');
		this.applyBackground(userPreferences.background ?? 'none');
		this.translateService.use(userPreferences.language ?? 'fr');
	}

	loadUserTheme() {
		const url = `${environment.serverUrl}/themes`;
		this.http.get<{ theme: string }>(url, {
			headers: this.authService.getSessionIdHeaders(),
			observe: 'body',
		}).subscribe((response) => this.applyTheme(response.theme));
	}

	loadUserBackground() {
		const url = `${environment.serverUrl}/background`;
		this.http.get<{ background: string }>(url, {
			headers: this.authService.getSessionIdHeaders(),
			observe: 'body',
		}).subscribe((response) => this.applyBackground(response.background));
	}

	setTheme(theme?: string) {
		theme ??= this.defaultTheme;
		this.applyTheme(theme);

		const updateUrl = `${environment.serverUrl}/themes`;
		this.http.put(updateUrl, { theme }, {
			headers: this.authService.getSessionIdHeaders(),
		}).subscribe();
	}

	setLanguage(language: string) {
		this.translateService.use(language);
		this.languageSubject.next(language);
	  }

	setBackground(background?: string) {
		background ??= this.defaultBackground;
		this.applyBackground(background);

		const updateUrl = `${environment.serverUrl}/background`;
		this.http.put(updateUrl, { background }, {
			headers: this.authService.getSessionIdHeaders(),
		}).subscribe();
	}

	private applyTheme(theme: string) {
		document.body.classList.remove(
			'lemon-theme',
			'oranges-theme',
			'strawberries-theme',
			'blueberries-theme',
			'watermelon-theme'
		);
		document.body.classList.add(theme);
		this.themeSubject.next(theme);
	}

	private applyBackground(background: string) {
		document.body.classList.remove(
			'bg-none',
			'bg-lemon',
			'bg-oranges',
			'bg-strawberries',
			'bg-blueberries',
			'bg-watermelon'
		);

		document.body.classList.add(`bg-${background}`);
		this.backgroundSubject.next(background);
	}
}