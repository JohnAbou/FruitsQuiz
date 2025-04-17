import { Service } from 'typedi';
import { Question } from '@common/interfaces/question';
import { QuestionType } from '@common/enums/question-type';
import { getValidAnswers, getExactValue } from '@app/utils/question.utils';
import { BaseGameObserver } from './base-observer';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';

@Service({ transient: true })
export class QuestionManager extends BaseGameObserver {
	// This constructor is needed to properly use the dependency injection
	// to provide the proper GameSessionBase to the base constructor
	// eslint-disable-next-line @typescript-eslint/no-useless-constructor
	constructor(game: GameSessionBase) {
		super(game);
	}

	protected setUpGameObserver(game: GameSessionBase): void {
		game.quizStartedSubject.subscribe(() => this.sendQuestionData());

		game.questionStartedSubject.subscribe(() => this.sendQuestionData());
		game.questionEndedSubject.subscribe((question: Question) => this.sendAnswers(question));
	}

	private sendQuestionData() {
		this.users.forEach((user) => user.emitToUser(GamePlaySocketEvent.SendQuestionData, this.question));
		this.organizer.emitToUser(GameAnswerSocketEvent.SendCorrectAnswer, this.getCorrectAnswer(this.question));
	}


	private sendAnswers(question: Question) {
		let correctAnswer = this.getCorrectAnswer(question);

		this.players.forEach((player) =>
			player.emitToUser(GameAnswerSocketEvent.SendCorrectAnswer, correctAnswer)
		);
	}

	private getCorrectAnswer(question: Question) {
		if (question.type === QuestionType.QRL) return 1;
		return (question.type === QuestionType.QCM) ? getValidAnswers(question) : getExactValue(question);
	}
}
