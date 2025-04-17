import { Socket } from 'socket.io';
import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { ClientHandlerService } from '@app/services/client/client-handler.service';
import { Client } from '@app/classes/client';

@Service()
export class GameSocket extends BaseSocketHandler {
    onConnection(socket: Socket): void {
        new ClientHandlerService(new Client(socket));
    }
}
