import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { GameLog } from '@common/interfaces/user-game-log';
import { UserAuthenticationService } from '@app/services/user-authentication.service';

@Injectable({
  providedIn: 'root'
})
export class GameLogService {
  private readonly baseUrl: string = environment.serverUrl + '/accounts';
  private gameLogsSubject = new BehaviorSubject<GameLog[]>([]);
  public gameLogs$ = this.gameLogsSubject.asObservable();

  constructor(
    private readonly http: HttpClient,
    private readonly authService: UserAuthenticationService
  ) {}

  fetchGameLogs(): Observable<GameLog[]> {
    return this.http.get<GameLog[]>(`${this.baseUrl}/me/game-logs`, { 
      headers: this.authService.getSessionIdHeaders() 
    }).pipe(
      map(logs => [...logs].reverse()),
      tap((logs) => {
        this.gameLogsSubject.next(logs);
      })
    );
  }
}
