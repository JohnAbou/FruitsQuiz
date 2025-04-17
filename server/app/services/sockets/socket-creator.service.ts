import { Server } from 'http';
import { Container, Service } from 'typedi';
import { SocketManager } from './socket-manager.service';
import { BaseSocketHandler } from './base-socket-handler';
import { ChatSocket } from './chat-socket.service';
import { GameSocket } from './game-socket.service';
import { SessionActivitySocket } from './session-activity-socket.service';
import { DataModifiedSocket } from './data-modified-socket.service';
import { FriendsSocketService } from './friends-socket.service';
import { UsersSocket } from './users-socket.service';
import { CurrencySocketService } from './currency-socket.service';

// the type we want to represent here is any constructor that create a class of type BaseSocketHandler
// the argument of the constructor does not really matter as the container will provide them for us
// which is why we have ...args: any[]
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type SocketHandlerConstructor<T extends BaseSocketHandler> = new (...args: any[]) => T;

@Service()
export class SocketCreatorService {
    static socketRegistry: SocketHandlerConstructor<BaseSocketHandler>[] = [
        DataModifiedSocket, GameSocket, ChatSocket, SessionActivitySocket, FriendsSocketService, UsersSocket, CurrencySocketService
    ];

    constructor(private socketManger: SocketManager) { }

    setUpSockets(server: Server) {
        this.socketManger.setUpHttpServer(server);

        SocketCreatorService.socketRegistry.forEach((socketHandler) => Container.get(socketHandler)?.setUpSocket());
    }
}
