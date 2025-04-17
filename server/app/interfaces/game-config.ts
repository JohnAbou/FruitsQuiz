import { Quiz } from '@common/interfaces/quiz';
import { GameType } from '@common/enums/game-type';
import { Player } from './users/player';

export interface GameConfig {
    organizer: Player;
    gameId: number;
    quiz: Quiz;
    futureGameType?: GameType;
}
