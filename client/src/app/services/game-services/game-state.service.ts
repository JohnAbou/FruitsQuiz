import { Injectable } from '@angular/core';
import { UserGameState } from '@common/enums/user-game-state';
import { UserGameRole } from '@common/enums/user-game-role';
import { BehaviorSubject } from 'rxjs';
import { GameListenerService } from './base-classes/game-listener.service';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';

@Injectable({
    providedIn: 'root',
})
export class GameStateService extends GameListenerService {
    private userStateSubject: BehaviorSubject<UserGameState>;
    private userRoleSubject: BehaviorSubject<UserGameRole>;

    getStateObservable() {
        return this.userStateSubject.asObservable();
    }

    getCurrentState() {
        return this.userStateSubject.value;
    }

    getRoleObservable() {
        return this.userRoleSubject.asObservable();
    }

    getCurrentRole() {
        return this.userRoleSubject.value;
    }

    setState(state: UserGameState) {
        this.userStateSubject.next(state);
    }

    setRole(role: UserGameRole) {
        this.userRoleSubject.next(role);
    }

    protected setUpSocket() {
        this.socketService.on(GamePlaySocketEvent.UpdateGameState, (state: UserGameState) => {
            this.setState(state);
        });

        this.socketService.on(GamePlaySocketEvent.UpdateGameRole, (role: UserGameRole) => {
            this.setRole(role);
        });
    }

    protected initializeState() {
        this.userStateSubject ??= new BehaviorSubject<UserGameState>(UserGameState.None);
        this.userStateSubject.next(UserGameState.None);

        this.userRoleSubject ??= new BehaviorSubject<UserGameRole>(UserGameRole.None);
        this.userRoleSubject.next(UserGameRole.None);
    }
}
