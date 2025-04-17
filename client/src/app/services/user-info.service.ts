import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { UserAuthenticationService } from './user-authentication.service';
import { BehaviorSubject, Observable, tap } from 'rxjs';
import { User } from '@app/interfaces/user';
import { catchError} from 'rxjs/operators';
import { of } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class UserInfoService {

    private userInfoSubject: BehaviorSubject<User> = new BehaviorSubject<User>(EMPTY_USER);

    get userObservable(): Observable<User> {
        return this.userInfoSubject.asObservable();
    }

    get user() {
        return this.userInfoSubject.value;
    }

    constructor(
        private readonly httpClient: HttpClient,
        private readonly authService: UserAuthenticationService,
    ) {
        this.authService.connectionEvent.subscribe((_) => this.loadUserInfo());

    }

    validateUsername(newUsername: string): string | null {
        if (newUsername.length < 4 || newUsername.length > 20) {
            return 'Le nombre de caractères doit être entre 4 et 20.';
        }
        return null;
    }

    updateUsername(newUsername: string) {
        return this.httpClient
            .put<{ success: boolean; error?: string }>(
                `${environment.serverUrl}/accounts/me/username`,
                { newUsername },
                { headers: this.authService.getSessionIdHeaders() }
            )
            .pipe(
                tap(response => {
                    if (response.success) {
                        this.updateUsernameSubject(newUsername);
                    }
                }),
                catchError((errorResponse) => {
                    const errorMessage = errorResponse.error?.error || 'AccountValidation.updateError';
                    return of({ success: false, error: errorMessage });
                })
            );
    }

    updateUsernameSubject(newUsername: string) {
        this.userInfoSubject.next({ ...this.userInfoSubject.value, username: newUsername });
    }

    setPredefinedAvatar(avatarUrl: string): Observable<{ avatarUrl: string }> {
        this.userInfoSubject.next({ ...this.userInfoSubject.value, activeAvatarId: avatarUrl });
        return this.httpClient.post<{ avatarUrl: string }>(
            `${environment.serverUrl}/accounts/me/avatar/select`, { avatarUrl },
            { headers: this.authService.getSessionIdHeaders() },
        );
    }

    updateUserAvatar(file: File): Observable<{ avatarId: string }> {
        const formData = new FormData();
        formData.append('image', file);

        return this.httpClient.post<{ avatarId: string }>(
            `${environment.serverUrl}/accounts/me/avatar/upload`, formData,
            { headers: new HttpHeaders({ 'x-session-id': this.authService.getSessionId() ?? '', }) }
        ).pipe(tap(() => this.loadUserInfo()));
    }

    private loadUserInfo() {
        this.httpClient
            .get<User>(`${environment.serverUrl}/accounts/me`, {
                headers: this.authService.getSessionIdHeaders(),
                observe: 'body',
                responseType: 'json',
            }).subscribe((user) => this.userInfoSubject.next(user));
    }
}

const EMPTY_USER: User = {
    activeAvatarId: '',
    email: '',
    id: '',
    username: '',
    avatarIds: [],
}
