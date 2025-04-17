import { Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';

@Injectable()
export class GameBaseService {
    protected socketService: SocketService;

    constructor(
        socketFactory: SocketFactoryService,
    ) {
        this.socketService = socketFactory.getSocket();
        
    }
}
