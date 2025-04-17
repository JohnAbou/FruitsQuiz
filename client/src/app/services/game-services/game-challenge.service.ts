import { Injectable } from '@angular/core';
import { GameListenerService } from './base-classes/game-listener.service';
import { BehaviorSubject } from 'rxjs';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';

@Injectable({
	providedIn: 'root',
})
export class GameChallengeService extends GameListenerService {
	private challengeSubject: BehaviorSubject<{code: number, price: number}>;
	private challengeResultSubject: BehaviorSubject<{success: boolean} | undefined>;

	get challengeObservable() { return this.challengeSubject.asObservable(); }
	get challengeResultObservable() { return this.challengeResultSubject.asObservable(); }

	get challenge() { return this.challengeSubject.getValue(); }
	get challengeResult() { return this.challengeResultSubject.getValue(); }

	protected setUpSocket() {
		this.socketService.on(GamePlayerSocketEvent.SendChallenge, (challengeDescription: {code: number, price: number}) => {
			this.challengeSubject.next(challengeDescription);
		});

		this.socketService.on(GamePlayerSocketEvent.SendChallengeResult, (challengeResult: {success: boolean}) => {
			this.challengeResultSubject.next(challengeResult);
		});
	}

	protected initializeState(): void {
		this.challengeSubject ??= new BehaviorSubject<{code: number, price: number}>({ code: 0, price:0 });
		this.challengeSubject.next({ code: 0, price:0 });

		this.challengeResultSubject ??= new BehaviorSubject<{success: boolean} | undefined>(undefined);
		this.challengeResultSubject.next(undefined);
	}
}
