import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { SocketService } from './socket-service/socket.service';
import { UserAuthenticationService } from './user-authentication.service';
import { SocketFactoryService } from './socket-service/socket-factory.service';

@Injectable({
	providedIn: 'root',
})
export class CurrencyService {
	private readonly currencySubject = new BehaviorSubject<number>(0);
	private readonly socketService: SocketService;

	private readonly boundHandlers = {
		onNewBalance: (data: { balance: number }) => this.currencySubject.next(data.balance)
	};

	get currencyObservable() { return this.currencySubject.asObservable(); }
	get currency() { return this.currencySubject.value; }

	constructor(
		private readonly authService: UserAuthenticationService,
		socketFactory: SocketFactoryService,
	) {
		this.socketService = socketFactory.getSocket();
		this.authService.connectionEvent.subscribe((_) => this.init());
		this.authService.disconnectEvent.subscribe(() => this.destroy());
	}

	private init() {
		this.socketService.on('currency-socket:newBalance', this.boundHandlers.onNewBalance);
		this.socketService.emit('currency-socket:join', this.authService.getSessionId());
	}

	private destroy() {
		this.socketService.off('currency-socket:newBalance', this.boundHandlers.onNewBalance);
	}
}
