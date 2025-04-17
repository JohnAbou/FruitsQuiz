import { BotDifficulty } from '../interfaces/bot-player';

export const BotAvatarsByDifficulty: Record<BotDifficulty, string[]> = {
    [BotDifficulty.Beginner]: ['beginner_lemon.png', 'beginner_grape.png', 'beginner_apple.png', 'beginner_orange.png'],
    [BotDifficulty.Intermediate]: ['intermediate_lemon.png', 'intermediate_grape.png', 'intermediate_apple.png', 'intermediate_orange.png'],
    [BotDifficulty.Expert]: ['expert_lemon.png', 'expert_grape.png', 'expert_apple.png', 'expert_orange.png'],
};
