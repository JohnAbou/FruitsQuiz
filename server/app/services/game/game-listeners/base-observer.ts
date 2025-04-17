import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Player } from '@app/interfaces/users/player';
import { QuestionWithIndex } from '@common/interfaces/question';

export abstract class BaseGameObserver {
    constructor(protected game: GameSessionBase) {
        this.setUpGameObserver(game);
    }

    get question(): QuestionWithIndex {
        return this.game.getQuestion();
    }

    get users(): Player[] {
        return this.game.users;
    }

    get players(): Player[] {
        return this.game.players;
    }

    get organizer(): Player {
        return this.game.organizer;
    }

    protected abstract setUpGameObserver(game: GameSessionBase): void;
}
