import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { environment } from 'src/environments/environment';
import { UserInfoService } from '@app/services/user-info.service';
import { PreferencesService } from '@app/services/preferences.service';
import { MatDialog } from '@angular/material/dialog';
import { LockedItemDialogComponent } from '../locked-item-dialog/locked-item-dialog';
import { Router } from '@angular/router';

interface ThemeOption {
  name: string;
  logoUrl: string;
  label: string;
  locked: boolean;
}

interface BackgroundOption {
  name: string;
  backgroundUrl: string | null;
  locked: boolean;
}

@Component({
  selector: 'app-preferences',
  templateUrl: './preferences.component.html',
  styleUrls: ['./preferences.component.scss']
})
export class PreferencesComponent implements OnInit {
  selectedLanguage: string;
  selectedTheme: string = 'lemon-theme';
  selectedBackground: string = 'none';

  private apiBaseUrl = environment.serverUrl;
  private languageUrl = `${this.apiBaseUrl}/language`;
  private themeUrl = `${this.apiBaseUrl}/theme`;
  private backgroundUrl = `${this.apiBaseUrl}/background`;
  private shopUrl = `${this.apiBaseUrl}/shop`;

  themes: ThemeOption[] = [
    { name: 'lemon-theme', logoUrl: 'assets/logo.png', label: 'PreferencesComponent.Lemon_theme', locked: false },
    { name: 'oranges-theme', logoUrl: 'assets/orangeslogo.png', label: 'PreferencesComponent.Orange_theme', locked: false },
    { name: 'strawberries-theme', logoUrl: 'assets/strawberrylogo.png', label: 'PreferencesComponent.Strawberry_theme', locked: true },
    { name: 'blueberries-theme', logoUrl: 'assets/blueberrylogo1.png', label: 'PreferencesComponent.Blueberry_theme', locked: true },
    { name: 'watermelon-theme', logoUrl: 'assets/watermelonlogo.png', label: 'PreferencesComponent.Watermelon_theme', locked: true }
  ];
  
  backgrounds: BackgroundOption[] = [
    { name: 'none', backgroundUrl: 'assets/none_icon.png', locked: false },
    { name: 'lemon', backgroundUrl: 'assets/lemonbackground.png', locked: true },
    { name: 'oranges', backgroundUrl: 'assets/orangesbackground.png', locked: true },
    { name: 'strawberries', backgroundUrl: 'assets/strawberrybackground.png', locked: true },
    { name: 'blueberries', backgroundUrl: 'assets/blueberrybackground.png', locked: true },
    { name: 'watermelon', backgroundUrl: 'assets/watermelonbackground.png', locked: true }
  ];
  
  constructor(
    private translate: TranslateService,
    private http: HttpClient,
    private userInfoService: UserInfoService,
    private themeService: PreferencesService,
    private dialog: MatDialog,
    private router: Router
  ) {
    this.selectedLanguage = this.translate.currentLang || 'fr';
    
    const savedTheme = localStorage.getItem('userTheme');
    const savedBackground = localStorage.getItem('userBackground');
    
    this.selectedTheme = savedTheme || 'lemon-theme';
    this.selectedBackground = savedBackground || 'none';
    
    this.themeService.themeChanges$.subscribe(theme => {
      this.selectedTheme = theme;
    });
    
    this.themeService.backgroundChanges$.subscribe(background => {
      this.selectedBackground = background;
    });
  }

  ngOnInit(): void {
    this.loadUserPreferences();
    this.loadUserShop();
  }

  loadUserShop(): void {
    const userId = this.userInfoService.user?.id;
    if (!userId) return;
    this.http.get<any>(`${this.shopUrl}/${userId}`).subscribe({
      next: (shop) => {
        if (shop?.items) {
          this.updateLockedStates(shop.items);
        }
      },
      error: (err) => {
        console.error('Error loading shop items:', err);
      }
    });
  }

  updateLockedStates(shopItems: any[]): void {
    this.themes.forEach(theme => {
      if (theme.name === 'lemon-theme' || theme.name === 'oranges-theme') {
        theme.locked = false;
        return;
      }
      const matchingItem = shopItems.find(item => 
        item.type === 'theme' && 
        this.getImageName(item.image) === this.getImageName(theme.logoUrl)
      );
      theme.locked = !(matchingItem && matchingItem.state === 1);
    });
  
    this.backgrounds.forEach(background => {
      if (background.name === 'none') {
        background.locked = false;
        return;
      }
      const matchingItem = shopItems.find(item => 
        item.type === 'background' && 
        this.getImageName(item.image) === this.getImageName(background.backgroundUrl)
      );
      background.locked = !(matchingItem && matchingItem.state === 1);
    });
  }
  
  private getImageName(path: string | null): string | null {
    if (!path) return null;
    return path.split('/').pop()?.split('?')[0] || null;
  }

  loadUserPreferences(): void {
    const userId = this.userInfoService.user?.id;
    if (!userId) return;
    
    this.http.get<{language: string}>(`${this.languageUrl}/${userId}`).subscribe(
      data => {
        if (data && data.language) {
          this.selectedLanguage = data.language;
          this.translate.use(this.selectedLanguage);
        }
      }
    );

    this.http.get<{theme: string}>(`${this.themeUrl}/${userId}`).subscribe(
      data => {
        if (data && data.theme) {
          this.selectedTheme = data.theme;
          this.themeService.setTheme(this.selectedTheme);
        }
      }
    );

    this.http.get<{background: string}>(`${this.backgroundUrl}/${userId}`).subscribe(
      data => {
        if (data && data.background) {
          this.selectedBackground = data.background;
          this.themeService.setBackground(this.selectedBackground);
        }
      }
    );
  }

  selectLanguage(language: string): void {
    this.selectedLanguage = language;
    this.translate.use(language);
    
    const userId = this.userInfoService.user?.id;
    if (userId) {
      this.http.post(`${this.languageUrl}/${userId}`, { language }).subscribe();
    }
  }

  isLanguageSelected(language: string): boolean {
    return this.selectedLanguage === language;
  }

  changeTheme(themeName: string): void {
    const theme = this.themes.find(t => t.name === themeName);
    if (!theme || theme.locked) return;
    
    this.selectedTheme = themeName;
    this.themeService.setTheme(themeName);
    
    const userId = this.userInfoService.user?.id;
    if (userId) {
      this.http.put(`${this.themeUrl}/${userId}`, { theme: themeName }).subscribe();
    }
  }

  selectBackground(backgroundName: string): void {
    const background = this.backgrounds.find(bg => bg.name === backgroundName);
    if (!background || background.locked) return;
    
    this.selectedBackground = backgroundName;
    this.themeService.setBackground(backgroundName);
    
    const userId = this.userInfoService.user?.id;
    if (userId) {
      this.http.put(`${this.backgroundUrl}/${userId}`, { background: backgroundName }).subscribe();
    }
  }

  isThemeSelected(themeName: string): boolean {
    return this.selectedTheme === themeName;
  }

  isBackgroundSelected(backgroundName: string): boolean {
    return this.selectedBackground === backgroundName;
  }

  getBackgroundUrl(): string | null {
    const background = this.backgrounds.find(bg => bg.name === this.selectedBackground);
    return background ? background.backgroundUrl : null;
  }
  
  // Methods to handle clicks on locked items
  handleThemeClick(theme: ThemeOption): void {
    if (theme.locked) {
      this.openLockedItemDialog();
    } else {
      this.changeTheme(theme.name);
    }
  }
  
  handleBackgroundClick(background: BackgroundOption): void {
    if (background.locked) {
      this.openLockedItemDialog();
    } else {
      this.selectBackground(background.name);
    }
  }
  
  openLockedItemDialog(): void {
    const dialogRef = this.dialog.open(LockedItemDialogComponent, {
      width: '350px',
      panelClass: 'locked-item-dialog'
    });
    
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.router.navigate(['/shop']);
      }
    });
  }
}
