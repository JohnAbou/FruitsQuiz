import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { AuthenticationLog } from '@common/interfaces/user-authentication-log';
import { UserAuthenticationService } from '@app/services/user-authentication.service';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationLogService {
  private readonly baseUrl: string = environment.serverUrl + '/accounts';
  private authLogsSubject = new BehaviorSubject<AuthenticationLog[]>([]);
  public authLogs$ = this.authLogsSubject.asObservable();

  constructor(
    private readonly http: HttpClient,
    private readonly authService: UserAuthenticationService
  ) {}

  fetchAuthenticationLogs(): Observable<AuthenticationLog[]> {
    return this.http.get<AuthenticationLog[]>(`${this.baseUrl}/me/authentication-logs`, { 
      headers: this.authService.getSessionIdHeaders() 
    }).pipe(
      map(logs => [...logs].reverse()),
      tap((logs) => {
        this.authLogsSubject.next(logs);
      })
    );
  }
}
