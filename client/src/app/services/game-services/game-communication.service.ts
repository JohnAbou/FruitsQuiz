import { HttpClient, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { GameHistory } from '@common/interfaces/game-history';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
    providedIn: 'root',
})
export class GameCommunicationService {

    private readonly baseUrl: string = environment.serverUrl;

    constructor(
        private readonly http: HttpClient,
    ) {
    }

    getGames(): Observable<GameHistory[]> {
        return this.http.get<GameHistory[]>(`${this.baseUrl}/game-history`);
    }

    deleteGames(): Observable<HttpResponse<string>> {
        return this.http.delete(`${this.baseUrl}/game-history`, { observe: 'response', responseType: 'text' });
    }
}
