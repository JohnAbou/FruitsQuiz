import { Player as PlayerClient } from '@common/interfaces/player';
import { Player } from '@app/interfaces/users/player';
import { BotPlayer } from '@app/classes/bot-player';

export const translatePlayer = (player: Player): PlayerClient | BotPlayer => {
    if (player instanceof BotPlayer) {
        return {
            name: player.name,
            score: player.score,
            bonusCount: player.bonusCount,
            roundSurvived: player.roundSurvived,
            difficulty: player.difficulty,
            avatarType: player.avatarType,
            averageAnswerTime: player.averageAnswerTime,
        };
    }

    return {
        name: player.name,
        score: player.score,
        bonusCount: player.bonusCount,
        roundSurvived: player.roundSurvived,
        averageAnswerTime: player.averageAnswerTime,
    };
};

export const translatePlayers = (players: Player[]): PlayerClient[] => {
    return players.map((player) => translatePlayer(player));
};
