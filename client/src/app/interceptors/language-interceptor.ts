import { Injectable } from '@angular/core';
import { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';

@Injectable()
export class LanguageInterceptor implements HttpInterceptor {

    constructor(private translateService: TranslateService) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const language = this.translateService.currentLang || 'fr';
    const clonedRequest = req.clone({
      setHeaders: {
        'Accept-Language': language
      }
    });
    return next.handle(clonedRequest);
  }
}
