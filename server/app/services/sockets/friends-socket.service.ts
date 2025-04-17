import { Service } from "typedi";
import { BaseSocketHandler } from "./base-socket-handler";
import { Socket } from "socket.io";
import { UsersSessionsService } from "../users/user-sessions.service";
import { FriendRequest } from "@app/interfaces/friends/friend-request";
import { Subject } from "rxjs";
import { UsernameModificationService } from "../users/username-modification.service";
import { UsernameModifiedEvent } from "@app/interfaces/users/username-modified-event";

@Service()
export class FriendsSocketService extends BaseSocketHandler {
    friendRequestSeen: Subject<string> = new Subject();

    private userSocketMap: Map<string, Socket> = new Map();

    constructor(
        private readonly sessionsService: UsersSessionsService,
        private readonly usernameModification: UsernameModificationService,
    ) {
        super();
        this.usernameModification.usernameModifiedEvent.subscribe(this.onUsernameModified.bind(this));
    }

    notifyUserOfRequestAnswered(accepterUsername: string, senderUsername: string, answer: boolean) {
        this.emitToUser(senderUsername, 'friend-socket:acceptedRequest', { accepterUsername, answer });
    }

    notifyUsersOfNewFriendShip(accepterUsername: string, senderUsername: string) {
        this.emitToUser(accepterUsername, 'friend-socket:addedFriend', senderUsername);
        this.emitToUser(senderUsername, 'friend-socket:addedFriend', accepterUsername);
    }

    notifyUserOfDeletedFriendShip(username1: string, username2: string) {
        this.emitToUser(username1, 'friend-socket:removedFriend', username2);
        this.emitToUser(username2, 'friend-socket:removedFriend', username1);
    }

    notifyUserOfNewRequest(request: FriendRequest) {
        this.emitToUser(request.receiverUsername, 'friend-socket:receivedRequest', request);
    }

    notifyUserOfRemovedRequest(request: FriendRequest, usernameToNotify: string) {
        this.emitToUser(usernameToNotify, 'friend-socket:removedRequest', request);
    }

    notifyUserOfRemovedFriend(friendUsername: string, usernameToNotify: string) {
        this.emitToUser(usernameToNotify, 'friend-socket:removedFriend', friendUsername);
    }

    notifyOfRequestUpdated() {
        this.socketManager.emit('friend-socket:requestUpdated');
    }

    notifyOfRelationUpdated() {
        this.socketManager.emit('friend-socket:relationUpdated');
    }

    onConnection(socket: Socket): void {
        socket.on('friend-socket:join', (sessionId) => this.join(socket, sessionId));
        socket.on('friend-socket:leave', () => this.leave(socket));
        socket.on('friend-socket:seenRequest', (requestId) => this.requestSeen(requestId));

        socket.on('disconnect', () => this.leave(socket));
    }

    private requestSeen(requestId: string) {
        this.friendRequestSeen.next(requestId);
    }

    private async join(socket: Socket, sessionId: string) {
        this.leave(socket);
        const user = await this.sessionsService.getUser(sessionId);
        if (!user) return;

        this.userSocketMap.set(user.username, socket);
    }

    private leave(socket: Socket) {
        for (const [username, savedSocket] of this.userSocketMap.entries()) {
            if (savedSocket.id !== socket.id) continue;
            this.userSocketMap.delete(username);
            break;
        }
    }

    private emitToUser<T>(username: string, event: string, data: T) {
        const userSocket = this.userSocketMap.get(username);
        if (!userSocket) return;

        userSocket.emit(event, data);
    }

    private onUsernameModified(usernameModifEvent: UsernameModifiedEvent) {
        if (!this.userSocketMap.has(usernameModifEvent.oldUsername)) return;

        const socket = this.userSocketMap.get(usernameModifEvent.oldUsername);
        this.userSocketMap.set(usernameModifEvent.newUsername, socket);
        this.userSocketMap.delete(usernameModifEvent.oldUsername);
    }
}
