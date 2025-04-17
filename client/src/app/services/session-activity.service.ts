import { Injectable } from '@angular/core';
import { SocketService } from './socket-service/socket.service';
import { SocketFactoryService } from './socket-service/socket-factory.service';

@Injectable({
    providedIn: 'root',
})
export class SessionActivityService {
    private socketService: SocketService;

    constructor(socketFacotry: SocketFactoryService) {
        this.socketService = socketFacotry.getSocket();
        window.addEventListener('beforeunload', () => this.disconnectSession());
    }

    startSession(sessionId: string) {
        const deviceType = 'desktop';
        this.socketService.emit('join', { sessionId, deviceType });
    }
    

    disconnectSession() {
        this.socketService.emit('forceDisconnect');
    }
}
