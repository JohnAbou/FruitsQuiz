import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { tap } from 'rxjs';
import { environment } from 'src/environments/environment';
import { AccountResponse, UserPreferences } from '@common/interfaces/response/account-response';
import { SessionActivityService } from './session-activity.service';

@Injectable({
    providedIn: 'root',
})
export class UserAuthenticationService {
    connectionEvent = new EventEmitter<string>();
    disconnectEvent = new EventEmitter<void>();
    preferencesEvent = new EventEmitter<UserPreferences>();
    
    private sessionId?: string;

    constructor(
        private readonly httpClient: HttpClient,
        private readonly sessionActivityService: SessionActivityService,
    ) { }

    isUserAuthenticated(): boolean {
        return !!this.sessionId;
    }

    getSessionId() {
        return this.sessionId;
    }

    getSessionIdHeaders() {
        return new HttpHeaders({
            'Content-Type': 'application/json',
            'x-session-id': this.sessionId ?? '',
        });
    }

    logOut() {
        this.sessionId = undefined;
        this.disconnectEvent.emit();
        this.sessionActivityService.disconnectSession();
    }

    attemptAuthentication(username: string, password: string) {
        return this.httpClient
            .post<AccountResponse>(`${environment.serverUrl}/accounts/login`, { username, password }, { observe: 'response', responseType: 'json' })
            .pipe(tap((response) => this.onSuccessfulAuth(response, username)));
    }

    attemptCreation(username: string, email: string, password: string, avatar: string) {
        return this.httpClient
            .post<AccountResponse>(`${environment.serverUrl}/accounts/register`, { username, email, password, avatar }, { observe: 'response', responseType: 'json' })
            .pipe(tap((response) => this.onSuccessfulAuth(response, username)));
    }

    onSuccessfulAuth(response: HttpResponse<AccountResponse>, username: string) {
        this.sessionId = response.body?.sessionId;
        this.sessionActivityService.startSession(this.sessionId as string);

        this.connectionEvent.emit(username);
        this.preferencesEvent.emit(response.body?.preferences as UserPreferences);
    }
}
