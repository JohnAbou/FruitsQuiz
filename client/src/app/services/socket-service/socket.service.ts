import { Socket, io } from 'socket.io-client';
import { environment } from 'src/environments/environment';

export class SocketService {
    private socket: Socket;

    constructor() {
        this.socket = io(environment.socketUrl, { transports: ['websocket'], upgrade: false, path: '/websocket' });
    }

    on<T>(eventName: string, callback: (arg0: T) => void) {
        this.socket.on(eventName, callback);
    }

    off<T>(eventName: string, callback: (arg0: T) => void) {
        this.socket.off(eventName, callback);
    }

    emit<ValueType, CallBackArgType>(eventName: string, value?: ValueType, ack?: (arg: CallBackArgType) => void) {
        const args: unknown[] = [];
        if (value) args.push(value);
        if (ack) args.push(ack);

        this.socket.emit(eventName, ...args);
    }

    emitWithAck<ValueType, CallBackArgType>(eventName: string, value?: ValueType): Promise<CallBackArgType> {
        return new Promise((resolve, reject) => {
            this.socket.timeout(5000).emit(eventName, value, (err: any, response: CallBackArgType) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(response);
                }
            });
        });
    }
}
