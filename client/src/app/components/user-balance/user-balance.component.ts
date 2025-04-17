import { Component } from '@angular/core';
import { CurrencyService } from '@app/services/currency.service';

@Component({
  selector: 'app-user-balance',
  templateUrl: './user-balance.component.html',
  styleUrls: ['./user-balance.component.scss']
})
export class UserBalanceComponent {
  constructor(private currencyService: CurrencyService) {}

  get userBalanceObservable() {
    return this.currencyService.currencyObservable;
  }
}
