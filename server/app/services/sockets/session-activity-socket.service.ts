import { Socket } from 'socket.io';
import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { UsersSessionsService } from '@app/services/users/user-sessions.service';
import { AuthenticationLogService } from '@app/services/users/user-authentication-log.service';

@Service()
export class SessionActivitySocket extends BaseSocketHandler {
    private sessionIds: Map<string, string> = new Map();

    constructor(
        private readonly sessionsService: UsersSessionsService,
        private readonly authenticationLogService: AuthenticationLogService,
    ) {
        super();
    }

    onConnection(socket: Socket) {
        socket.on('join', async (data: { sessionId: string; deviceType: string }) => {
            await this.onJoin(socket, data.sessionId, data.deviceType);
        });
        socket.on('forceDisconnect', () => this.onDisconnect(socket.id));
        socket.on('disconnect', () => this.onDisconnect(socket.id));
    }
    
    private async onJoin(socket: Socket, sessionId: string, deviceType: string) {
        if (!sessionId) return;
        this.sessionIds.set(socket.id, sessionId);
        const userId = this.sessionsService.getUserIdFromSession(sessionId);
        if (userId) {
            await this.authenticationLogService.recordLogin(userId, sessionId, deviceType);
        }
    }
    

    private async onDisconnect(socketId: string) {
        const sessionId = this.sessionIds.get(socketId);
        if (sessionId) {
            await this.authenticationLogService.recordLogout(sessionId);
            this.sessionIds.delete(socketId);
            this.sessionsService.closeUserSession(sessionId);
        }
    }
}
