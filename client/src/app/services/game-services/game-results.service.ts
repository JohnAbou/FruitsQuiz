import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { GameListenerService } from './base-classes/game-listener.service';
import { GameResult } from '@app/interfaces/game-result';
import { WinStreakUpdate } from '@app/interfaces/win-streak-update';
import { GameMetricsUpdate } from '@app/interfaces/game-metrics-update';

@Injectable({
    providedIn: 'root',
})
export class GameResultsService extends GameListenerService {
    private gameResultSubject: BehaviorSubject<GameResult>;
    private winStreakSubject: BehaviorSubject<WinStreakUpdate>;
    private gameMetricsSubject: BehaviorSubject<GameMetricsUpdate>;
    private gameTimeSubject: BehaviorSubject<{ currentTime: number, addedTime: number }>;

    get gameResult() {
        return this.gameResultSubject.asObservable();
    }

    get winStreakUpdate() {
        return this.winStreakSubject.asObservable();
    }

    get gameMetricsUpdate() {
        return this.gameMetricsSubject.asObservable();
    }

    get gameTimeUpdate() {
        return this.gameTimeSubject.asObservable();
    }

    protected setUpSocket() {
        this.socketService.on('sendGameResult', (result: GameResult) => this.gameResultSubject.next(result));
        this.socketService.on('gameWinStreakUpdated', (update: WinStreakUpdate) => this.winStreakSubject.next(update));
        this.socketService.on('gameMetricsUpdated', (update: GameMetricsUpdate) => this.gameMetricsSubject.next(update));
        this.socketService.on('gameTimeUpdated', (update: { currentTime: number, addedTime: number }) => this.gameTimeSubject.next(update));
    }

    protected initializeState() {
        this.gameTimeSubject ??= new BehaviorSubject({ currentTime: 0, addedTime: 0 });
        this.gameTimeSubject.next({ currentTime: 0, addedTime: 0 });

        this.gameMetricsSubject ??= new BehaviorSubject<GameMetricsUpdate>({ newPoints: 0, gainedPoints: 0, newSurvivedQuestion: 0, gainedSurvivedQuestion: 0 });
        this.gameMetricsSubject.next({ newPoints: 0, gainedPoints: 0, newSurvivedQuestion: 0, gainedSurvivedQuestion: 0 });

        this.gameResultSubject ??= new BehaviorSubject<GameResult>({ wasTie: false });
        this.gameResultSubject.next({ wasTie: false });

        this.winStreakSubject ??= new BehaviorSubject<WinStreakUpdate>({ wsState: 1, current: 0, winCount: 0 });
        this.winStreakSubject.next({ wsState: 1, current: 0, winCount: 0 });
    }
}
