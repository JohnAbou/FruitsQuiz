import { Socket } from 'socket.io';
import { SocketManager } from './socket-manager.service';
import { Container, Service } from 'typedi';

@Service()
export abstract class BaseSocketHandler {
    protected socketManager: SocketManager;

    constructor() {
        this.socketManager = Container.get(SocketManager);
    }

    // This is a method that socket handler can override
    // if they need to add any event handler to the socket connection
    // we need the unused argument as it is part of the signature of the function
    // eslint-disable-next-line
    onConnection(socket: Socket) {
        // By default we dont need to add any event handler so it is empty
    }

    setUpSocket() {
        this.socketManager.setUpConnection(this);
    }
}
