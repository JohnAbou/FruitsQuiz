import { Injectable } from '@angular/core';
import { GameStateService } from './game-services/game-state.service';
import { UserGameState } from '@common/enums/user-game-state';
import { BehaviorSubject } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class AvatarNavigationService {
    private canNavigateSafelySubject = new BehaviorSubject(true);

    get canNavigateSafely$() {
        return this.canNavigateSafelySubject.asObservable();
    }

    get canNavigateSafely() {
        return this.canNavigateSafelySubject.getValue();
    }

    constructor(private gameStateService: GameStateService) {
        this.gameStateService.getStateObservable().subscribe((newState) => this.onStateChange(newState));
    }

    private onStateChange(state: UserGameState) {
        this.canNavigateSafelySubject.next(state === UserGameState.None);
    }
}
