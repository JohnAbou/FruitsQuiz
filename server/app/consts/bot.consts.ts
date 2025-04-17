import { BotDifficulty } from '@common/interfaces/bot-player';

// Delay for answering the question ( % of the question duration )
export const DELAY_FACTORS = {
    [BotDifficulty.Beginner]: [0.5, 0.9],
    [BotDifficulty.Intermediate]: [0.3, 0.7],
    [BotDifficulty.Expert]: [0.1, 0.5],
};

// Delay after all players answered so that the worse bots answer last ( Elimination mode )
export const SMALL_DELAYS = {
    [BotDifficulty.Beginner]: 200,
    [BotDifficulty.Intermediate]: 100,
    [BotDifficulty.Expert]: 0,
};

// Base probability of a bot answering correctly for a question with 2 choices
export const BASE_PROBABILITIES: Record<BotDifficulty, number> = {
    [BotDifficulty.Beginner]: 0.3,
    [BotDifficulty.Intermediate]: 0.6,
    [BotDifficulty.Expert]: 0.8,
};

// Factor to reduce the probability of a bot answering correctly based on the number of choices
export const DECAY_FACTOR: Record<BotDifficulty, number> = {
    [BotDifficulty.Beginner]: 1,
    [BotDifficulty.Intermediate]: 0.8,
    [BotDifficulty.Expert]: 0.2,
};
