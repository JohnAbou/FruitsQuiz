import { Player } from './player';

export interface BotPlayer extends Player {
    difficulty: BotDifficulty;
    avatarType: BotAvatarType;
}

export enum BotDifficulty {
    Beginner = 'Beginner',
    Intermediate = 'Intermediate',
    Expert = 'Expert',
}

export enum BotAvatarType {
    LEMON = 'lemon',
    ORANGE = 'orange',
    APPLE = 'apple',
    GRAPE = 'grape',
}

export function isBotPlayer(player: Player): player is BotPlayer {
    return 'difficulty' in player;
}
