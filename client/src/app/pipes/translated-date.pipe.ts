import { Pipe, PipeTransform } from '@angular/core';
import { DatePipe } from '@angular/common';
import { TranslateService } from '@ngx-translate/core';

@Pipe({
  name: 'translatedDate',
  pure: false 
})
export class TranslatedDatePipe implements PipeTransform {
  constructor(private translate: TranslateService) {}

  transform(value: any, format: string = 'medium'): string | null {
    if (!value) return null;
    
    const locale = this.translate.currentLang || 'en';
    
    try {
      const datePipe = new DatePipe(locale);
      return datePipe.transform(value, format);
    } catch (error) {
      console.warn(`Error using locale ${locale} for date pipe, falling back to 'en'`, error);
      const fallbackPipe = new DatePipe('en');
      return fallbackPipe.transform(value, format);
    }
  }
}
