import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { MatButtonToggleChange } from '@angular/material/button-toggle';
import { UserInfoService } from '@app/services/user-info.service';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { first } from 'rxjs/operators';
import { CurrencyService } from '@app/services/currency.service';
import { TranslateService } from '@ngx-translate/core';

type ItemState = 0 | 1;
type ItemType = 'all' | 'avatar' | 'background' | 'theme';

@Component({
  selector: 'app-shop-page',
  templateUrl: './shop-page.component.html',
  styleUrls: ['./shop-page.component.scss']
})
export class ShopPageComponent implements OnInit {
  userId: string;
  loading: boolean = true;
  
  currentFilter: ItemType = 'all';
  filterOptions: ItemType[] = ['all', 'avatar', 'background', 'theme'];

  get userBalance() {
    return this.currencyService.currency;
  }

  get userBalanceObservable() {
    return this.currencyService.currencyObservable;
  }

  items: ShopItem[] = [];

  constructor(
    private cdr: ChangeDetectorRef, 
    private userInfoService: UserInfoService,
    private http: HttpClient,
    private currencyService: CurrencyService,
    private translate: TranslateService
  ) {
    this.userId = this.userInfoService.user.id;
  }

  ngOnInit(): void {
    this.loadUserData();
  }

  async loadUserData(): Promise<void> {
    this.loading = true;
    
    try {
      await this.loadShopItems();
    } catch (error) {
      console.error('Error loading user data:', error);
    } finally {
      this.loading = false;
      this.cdr.detectChanges();
    }
  }

  async loadShopItems(): Promise<void> {
    try {
      const response: any = await this.http.get(`${environment.serverUrl}/shop/${this.userId}`)
        .pipe(first()).toPromise();
      
      if (response && response.items) {
        this.items = response.items;
      }
      this.cdr.detectChanges();
    } catch (error) {
      console.error('Error loading shop items:', error);
    }
  }

  async saveShopItems(): Promise<void> {
    try {
      await this.http.post(`${environment.serverUrl}/shop/${this.userId}`, { 
        items: this.items 
      }).pipe(first()).toPromise();
    } catch (error) {
      console.error('Error saving shop items:', error);
    }
  }

  async buyItem(item: ShopItem): Promise<void> {
    if (item.state !== 0 || this.userBalance < item.price) {
      return;
    }

    try {
      const response: any = await this.http.post(`${environment.serverUrl}/currency/${this.userId}/remove`, {
        amount: item.price
      }).pipe(first()).toPromise();

      if (response && response.success) {
        item.state = 1; 
        
        await this.saveShopItems();
        
        this.cdr.detectChanges();
      } else {
        console.error('Failed to buy item:', response?.message || 'Insufficient funds');
      }
    } catch (error) {
      console.error('Error buying item:', error);
    }
  }
  
  getButtonText(item: ShopItem): string {
    return item.state === 0 
      ? this.translate.instant('ShopPage.Buy') 
      : this.translate.instant('ShopPage.Bought');
  }
  
  async handleItemAction(item: ShopItem): Promise<void> {
    if (item.state === 0) {
      await this.buyItem(item);
    }
  }

  onFilterChange(event: MatButtonToggleChange): void {
    this.currentFilter = event.value as ItemType;
    this.cdr.detectChanges();
  }

  get filteredItems(): ShopItem[] {
    if (this.currentFilter === 'all') {
      return this.items;
    } else {
      return this.items.filter(item => item.type === this.currentFilter);
    }
  }
}

interface ShopItem {
  id: number;
  name: string;
  image: string;
  type: string;
  price: number;
  state: ItemState;
}
