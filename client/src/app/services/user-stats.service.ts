import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { UserStats, UserWithStats } from '@app/interfaces/user-stats';
import { UserAuthenticationService } from './user-authentication.service';


@Injectable({
    providedIn: 'root',
})
export class UserStatsService {
    constructor(
        private readonly httpClient: HttpClient,
        private readonly authService: UserAuthenticationService
    ) {}

    getUserStats(userId: string) {
        return this.httpClient.get<UserStats>(`${environment.serverUrl}/accounts/stats/${userId}`, {
            observe: 'body',
            responseType: 'json',
        });
    }

    getUsersStats() {
        return this.httpClient.get<UserWithStats[]>(`${environment.serverUrl}/accounts/stats/all`, {
            observe: 'body',
            responseType: 'json',
        });
    }

    getUserPersonalStats() {
        return this.httpClient.get<UserStats>(`${environment.serverUrl}/accounts/me/stats`, {
            headers: this.authService.getSessionIdHeaders(),
            observe: 'body',
            responseType: 'json',
        });
    }
}
