import { BotPlayer } from '@app/classes/bot-player';
import { DECAY_FACTOR, SMALL_DELAYS, BASE_PROBABILITIES, DELAY_FACTORS } from '@app/consts/bot.consts';
import { QuestionType } from '@common/enums/question-type';
import { AnswerToCorrect } from '@common/interfaces/answers/answer-to-correct';
import { BotDifficulty } from '@common/interfaces/bot-player';
import { Choice } from '@common/interfaces/choice';
import { Player } from '@app/interfaces/users/player';
import { Question } from '@common/interfaces/question';
import { Estimations } from '@common/interfaces/question-estimations';
import { Service } from 'typedi';

@Service()
export class BotAnswerService {
    botTimers = new Map<string, Map<BotPlayer, { startTimeMS: number; timeout: NodeJS.Timeout; delay: number }>>();
    pausedTimers = new Map<string, Map<BotPlayer, number>>();
    allNonBotsSubmitted = false;
    private submitPlayerAnswer: (player: Player) => void;

    getBotQRLAnswer(bot: BotPlayer): AnswerToCorrect {
        return { playerName: bot.name, score: BASE_PROBABILITIES[bot.difficulty], answer: '' };
    }

    getBotQREAnswer(bot: BotPlayer, estimation: Estimations): number {
        const { exactValue, lowerBound, upperBound, toleranceMargin } = estimation;

        if (bot.difficulty === BotDifficulty.Beginner) {
            return this.getBadGuess(lowerBound, upperBound);
        }

        const sigmaMap = {
            [BotDifficulty.Intermediate]: toleranceMargin * 2,
            [BotDifficulty.Expert]: toleranceMargin * 0.7,
        };

        return this.getTruncatedGaussianRandom(exactValue, sigmaMap[bot.difficulty], lowerBound, upperBound);
    }

    getBotQcmAnswer(difficulty: BotDifficulty, choices: Choice[]): number[] {
        return this.weightedChoice(choices, this.getCorrectProbability(difficulty, choices.length));
    }

    getRandomDelay(difficulty: BotDifficulty, questionDuration: number): number {
        const [minFactor, maxFactor] = DELAY_FACTORS[difficulty];
        const minDelay = Math.floor(questionDuration * 1000 * minFactor);
        const maxDelay = Math.floor(questionDuration * 1000 * maxFactor);

        return Math.floor(Math.random() * (maxDelay - minDelay + 1)) + minDelay;
    }

    handleBotAnswers(
        players: Player[],
        question: Question,
        toggleAnswerChoice: (player: Player, choice: number) => void,
        updateResponse: (player: Player, response: string) => void,
        submitNumericAnswer: (player: Player, answer: number) => void,
    ) {
        if (question.type === QuestionType.QCM) {
            this.handleBotQCMAnswers(players, question.choices, toggleAnswerChoice);
        }
        if (question.type === QuestionType.QRL) {
            this.handleBotQRLAnswers(players, updateResponse);
        }
        if (question.type === QuestionType.QRE) {
            this.handleBotQREAnswers(players, question.estimations, submitNumericAnswer);
        }
    }

    handleAllNonBotsSubmitted(gameId: string, submitPlayerAnswer: (player: Player) => void) {
        const gameTimers = this.botTimers.get(gameId);
        if (!gameTimers) return;

        gameTimers.forEach((timerData, player) => {
            if (player instanceof BotPlayer) {
                clearTimeout(timerData.timeout);

                const newDelay = SMALL_DELAYS[player.difficulty];
                const newTimer = setTimeout(() => {
                    submitPlayerAnswer(player);
                    gameTimers.delete(player);
                }, newDelay);

                gameTimers.set(player, { ...timerData, timeout: newTimer, delay: newDelay });
            }
        });
    }

    startBotTimers(gameId: string, players: Player[], quizDuration: number, submitPlayerAnswer: (player: Player) => void) {
        this.submitPlayerAnswer = submitPlayerAnswer;

        if (!this.botTimers.has(gameId)) {
            this.botTimers.set(gameId, new Map<BotPlayer, { startTimeMS: number; timeout: NodeJS.Timeout; delay: number }>());
        }

        const gameTimers = this.botTimers.get(gameId)!;

        players.forEach((player) => {
            if (!(player instanceof BotPlayer)) return;

            const delay = this.getRandomDelay(player.difficulty, quizDuration);

            const startTimeMS = new Date().getTime();
            const timer = setTimeout(() => {
                submitPlayerAnswer(player);
                gameTimers.delete(player);
            }, delay);

            gameTimers.set(player, { startTimeMS, timeout: timer, delay });
        });
    }

    pauseBotTimers(gameId: string) {
        const gameTimers = this.botTimers.get(gameId);
        if (!gameTimers) return;

        if (!this.pausedTimers.has(gameId)) {
            this.pausedTimers.set(gameId, new Map<BotPlayer, number>());
        }
        const pausedGameTimers = this.pausedTimers.get(gameId)!;

        gameTimers.forEach((timerData, player) => {
            const { timeout, startTimeMS, delay } = timerData;

            const currentTime = new Date().getTime();
            const elapsedTime = currentTime - startTimeMS;
            const remainingTime = Math.max(0, delay - elapsedTime);

            clearTimeout(timeout);
            pausedGameTimers.set(player, remainingTime);
        });
    }

    resumeBotTimers(gameId: string) {
        const pausedGameTimers = this.pausedTimers.get(gameId);
        if (!pausedGameTimers) return;

        if (!this.botTimers.has(gameId)) {
            this.botTimers.set(gameId, new Map<BotPlayer, { startTimeMS: number; timeout: NodeJS.Timeout; delay: number }>());
        }
        const gameTimers = this.botTimers.get(gameId)!;

        pausedGameTimers.forEach((remainingTime, player) => {
            const startTimeMS = new Date().getTime();
            const newTimer = setTimeout(() => {
                this.submitPlayerAnswer(player);
                gameTimers.delete(player);
            }, remainingTime);

            gameTimers.set(player, { startTimeMS, timeout: newTimer, delay: remainingTime });
        });

        this.pausedTimers.delete(gameId);
    }

    activatePanicMode(gameId: string) {
        const gameTimers = this.botTimers.get(gameId);
        if (!gameTimers) return;

        gameTimers.forEach((timerData, player) => {
            const { timeout, startTimeMS, delay } = timerData;
            clearTimeout(timeout);
            const currentTime = new Date().getTime();
            const elapsedTime = currentTime - startTimeMS;
            const remainingTime = Math.max(0, delay - elapsedTime);
            const dividedTime = Math.max(1, remainingTime / 4);

            const newTimer = setTimeout(() => {
                this.submitPlayerAnswer(player);
                gameTimers.delete(player);
            }, dividedTime);

            gameTimers.set(player, { startTimeMS, timeout: newTimer, delay: dividedTime });
        });
    }

    private weightedChoice(choices: Choice[], correctProbability: number): number[] {
        const correctIndices = choices.map((choice, index) => (choice.isCorrect ? index : -1)).filter((index) => index !== -1);

        const incorrectIndices = choices.map((_, index) => index).filter((index) => !correctIndices.includes(index));

        if (Math.random() < correctProbability) {
            return correctIndices;
        } else {
            return [incorrectIndices[Math.floor(Math.random() * incorrectIndices.length)]];
        }
    }

    private getCorrectProbability(difficulty: BotDifficulty, numChoices: number): number {
        const P2 = BASE_PROBABILITIES[difficulty];
        const b = DECAY_FACTOR[difficulty];

        return P2 * Math.pow(2 / numChoices, b);
    }

    private getTruncatedGaussianRandom(mean: number, stdDev: number, lowerBound: number, upperBound: number): number {
        let guess: number;

        do {
            guess = this.getGaussianRandom(mean, stdDev);
        } while (guess < lowerBound || guess > upperBound);

        return guess;
    }

    private getGaussianRandom(mean: number, stdDev: number): number {
        const u = 1 - Math.random();
        const v = 1 - Math.random();
        const z = Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
        return Math.round(mean + z * stdDev);
    }

    private getBadGuess(lowerBound: number, upperBound: number): number {
        const betaValue = this.getSkewedBetaRandom(1, 10);
        const randomFactor = Math.random() > 0.5 ? 1 : -1;

        return lowerBound + randomFactor * betaValue * (upperBound - lowerBound);
    }

    private getSkewedBetaRandom(alpha: number, beta: number): number {
        const gamma1 = this.getGammaRandom(alpha);
        const gamma2 = this.getGammaRandom(beta);
        return gamma1 / (gamma1 + gamma2);
    }

    private getGammaRandom(shape: number): number {
        let d = 0;
        for (let i = 0; i < shape; i++) {
            d += Math.random();
        }
        return d;
    }

    private handleBotQCMAnswers(players: Player[], choices: Choice[], toggleAnswerChoice: (player: Player, choice: number) => void) {
        players.forEach((player) => {
            if (player instanceof BotPlayer) {
                const botChoices = this.getBotQcmAnswer(player.difficulty, choices);
                botChoices.forEach((choice) => {
                    toggleAnswerChoice(player, choice);
                });
            }
        });
    }

    private handleBotQRLAnswers(players: Player[], updateResponse: (player: Player, response: string) => void) {
        players.forEach((player) => {
            if (player instanceof BotPlayer) {
                updateResponse(player, '');
            }
        });
    }

    private handleBotQREAnswers(players: Player[], estimations: Estimations, submitNumericAnswer: (player: Player, answer: number) => void) {
        players.forEach((player) => {
            if (player instanceof BotPlayer) {
                const botAnswer = this.getBotQREAnswer(player, estimations);
                submitNumericAnswer(player, botAnswer);
            }
        });
    }
}
