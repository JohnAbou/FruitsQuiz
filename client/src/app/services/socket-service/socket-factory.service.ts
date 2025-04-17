import { Injectable } from '@angular/core';
import { SocketService } from './socket.service';

@Injectable({
    providedIn: 'root',
})
export class SocketFactoryService {
    private socket: SocketService;

    // The goal of this factory is to provide different instance of the socket service instead of having a singleton
    getSocket(): SocketService {
        if (!this.socket) this.createSocket();
        return this.socket as SocketService;
    }

    private createSocket() {
        this.socket = new SocketService();
    }
}
