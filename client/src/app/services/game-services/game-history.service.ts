import { Injectable } from '@angular/core';
import { GameHistory } from '@common/interfaces/game-history';
import { BehaviorSubject, Observable } from 'rxjs';
import { GameCommunicationService } from './game-communication.service';

@Injectable({
    providedIn: 'root',
})
export class GameHistoryService {
    private gameHistoriesSubject = new BehaviorSubject<GameHistory[]>([]);

    constructor(private readonly gameCommunicationService: GameCommunicationService) {
        this.loadGames();
    }

    deleteGames(): void {
        this.gameCommunicationService.deleteGames().subscribe();
    }

    getGameObservable(): Observable<GameHistory[]> {
        return this.gameHistoriesSubject.asObservable();
    }

    private loadGames(): void {
        this.gameCommunicationService.getGames().subscribe((games) => this.gameHistoriesSubject.next(games));
    }
}
