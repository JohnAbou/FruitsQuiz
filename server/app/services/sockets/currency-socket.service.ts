import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { Socket } from 'socket.io';
import { UsersSessionsService } from '../users/user-sessions.service';
import { UserDataManager } from '../data/user-data-manager.service';

@Service()
export class CurrencySocketService extends BaseSocketHandler {
    private userSocketMap: Map<string, Socket> = new Map(); // userId -> socket

    constructor(
        private readonly sessionsService: UsersSessionsService,
        private readonly userDataManager: UserDataManager,
    ) {
        super();
        this.userDataManager.currencyUpdateEvent.subscribe((event) => this.sendNewBalance(event.userId, event.newBalance));
    }

    sendNewBalance(userId: string, balance: number) {
        this.emitToUser(userId, 'currency-socket:newBalance', { balance });
    }

    onConnection(socket: Socket): void {
        socket.on('currency-socket:join', (sessionId) => this.join(socket, sessionId));
        socket.on('currency-socket:leave', () => this.leave(socket));

        socket.on('disconnect', () => this.leave(socket));
    }

    private async join(socket: Socket, sessionId: string) {
        this.leave(socket);
        const user = await this.sessionsService.getUser(sessionId);
        if (!user) return;

        this.userSocketMap.set(user.id, socket);

        this.sendNewBalance(user.id, await this.userDataManager.getUserCurrency(user.id));
    }

    private leave(socket: Socket) {
        for (const [userId, savedSocket] of this.userSocketMap.entries()) {
            if (savedSocket.id !== socket.id) continue;
            this.userSocketMap.delete(userId);
            break;
        }
    }

    private emitToUser<T>(userId: string, event: string, data: T) {
        const userSocket = this.userSocketMap.get(userId);
        if (!userSocket) return;

        userSocket.emit(event, data);
    }
}
