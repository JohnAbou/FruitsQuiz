import { Player } from '@app/interfaces/users/player';
import { Service } from 'typedi';

interface TimeInfo {
    averageTime: number;
    answerCount: number;
}

@Service({ transient: true })
export class AnswerTimerService {
    private startTime: Date;
    private answerTimes = new Map<string, TimeInfo>();

    onQuestionStart() {
        this.startTime = new Date();
    }

    onPlayerSubmission(player: Player) {
        const currentTimeInfo = this.answerTimes.get(player.id) ?? { averageTime: 0, answerCount: 0 };

        const answerTime = (new Date().getTime() - this.startTime.getTime()) / 1000;
        currentTimeInfo.averageTime += answerTime / ++currentTimeInfo.answerCount;

        player.averageAnswerTime = currentTimeInfo.averageTime;
        this.answerTimes.set(player.id, currentTimeInfo);
    }

    onQuestionEnded(players: Player[]) {
        players.forEach((player) => this.onPlayerSubmission(player));
    }
}
