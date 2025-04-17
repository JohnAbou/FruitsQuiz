import * as http from 'http';
import * as io from 'socket.io';
import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';

@Service()
export class SocketManager {
    private server: http.Server | null;
    private sio: io.Server | null;

    setUpHttpServer(server: http.Server) {
        this.server = server;
        this.sio = new io.Server(this.server, {
            cors: { origin: '*', methods: ['GET', 'POST'] },
            path: '/websocket',
        });
    }

    setUpConnection(socketHandler: BaseSocketHandler) {
        this.sio.on('connection', (socket) => {
            socketHandler.onConnection(socket);
        });
    }

    emit<T>(event: string, emitValue?: T) {
        if (emitValue) this.sio.sockets.emit(event, emitValue);
        else this.sio.sockets.emit(event);
    }

    emitToRoom<T>(room: string, event: string, emitValue?: T) {
        if (emitValue) this.sio.to(room).emit(event, emitValue);
        else this.sio.to(room).emit(event);
    }

    emitToRoomWithAck<T, R = any>(room: string, event: string, emitValue: T, onResponse: (response: R, socketId: string) => void) {
        this.sio
            ?.in(room)
            .fetchSockets()
            .then((sockets) => {
                sockets.forEach((socket) => {
                    socket.timeout(5000).emit(event, emitValue, (err: any, response: R) => {
                        if (!err) {
                            onResponse(response, socket.id);
                        }
                    });
                });
            });
    }
}
