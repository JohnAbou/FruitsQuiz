import Container, { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { DataModifiedSocket } from '@app/services/sockets/data-modified-socket.service';
import { GameManagerService } from '../game-manager.service';

@Service({ transient: true })
export class GameModifiedService extends BaseGameObserver {
    constructor(
        game: GameSessionBase,
        private dataModifiedSocket: DataModifiedSocket,
    ) {
        super(game);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.gameInfoChangedSubject.subscribe(
            () => this.dataModifiedSocket.emitGameInfoChangedNotification(Container.get(GameManagerService).getGamesInfo())
        );
    }
}
