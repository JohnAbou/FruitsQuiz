import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { UserChatsService } from '@app/services/user-chats.service';

@Service({ transient: true })
export class GameChatDeleter extends BaseGameObserver {
    constructor(
        game: GameSessionBase,
        private userChatService: UserChatsService,
    ) {
        super(game);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        const subscriptions = [
            game.removedGameSubject.subscribe(() => {
                this.userChatService.deleteGameChat(game.gameId.toString());
                subscriptions.forEach((subscription) => subscription.unsubscribe());
            }),
        ];
    }
}
