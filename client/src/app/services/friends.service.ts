import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, BehaviorSubject, of, combineLatest, map } from 'rxjs';
import { environment } from 'src/environments/environment';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { FriendRequest } from '@app/interfaces/friend-request';
import { SocketFactoryService } from './socket-service/socket-factory.service';
import { SocketService } from './socket-service/socket.service';
import { TranslateService } from '@ngx-translate/core';
import { DialogModalService } from './dialog-modal.service';
import { NotificationComponent } from '@app/components/notification/notification.component';
import { PrivateProfileService } from './private-profile.service';
import { FriendStatus } from '@app/enums/friend-status.enum';
import { UserInfoService } from './user-info.service';
import { ChatsService } from './chat-services/chats-service';
import { AudioService } from '@app/services/audio.service';
import { NOTIFICATION_SOUND_MP3 } from '@app/consts/file-consts';

@Injectable({
    providedIn: 'root',
})
export class FriendsService {
    private friendsSubject = new BehaviorSubject<string[]>([]);
    private sentRequestsSubject = new BehaviorSubject<FriendRequest[]>([]);
    private receivedRequestsSubject = new BehaviorSubject<FriendRequest[]>([]);

    private readonly baseUrl: string = environment.serverUrl + '/accounts';
    private readonly socketService: SocketService;

    private readonly boundHandlers = {
        receivedRequest: this.addReceivedRequest.bind(this),
        removedRequest: this.removeReceivedRequest.bind(this),
        acceptedRequest: this.onAcceptedRequest.bind(this),
        removedFriend: this.friendRemoved.bind(this),
        addedFriend: this.friendAdded.bind(this),
        requestUpdated: this.requestUpdated.bind(this),
        relationUpdated: this.refreshFriends.bind(this)
    };

    get friendsObservable() { return this.friendsSubject.asObservable(); }
    get sentRequestsObservable() { return this.sentRequestsSubject.asObservable(); }
    get receivedRequestsObservable() { return this.receivedRequestsSubject.asObservable(); }

    constructor(
        private readonly http: HttpClient,
        private readonly authService: UserAuthenticationService,
        private readonly userInfoService: UserInfoService,
        private readonly dialogModalService: DialogModalService,
        private readonly translate: TranslateService,
        private readonly privateProfile: PrivateProfileService,
        private readonly chatsService: ChatsService,
        private readonly audioService: AudioService,
        socketFactory: SocketFactoryService,
    ) {
        this.socketService = socketFactory.getSocket();

        this.authService.connectionEvent.subscribe((_) => this.init());
        this.authService.disconnectEvent.subscribe(() => this.destroy());
    }

    getFriends(): Observable<string[]> {
        return this.http.get<string[]>(
            `${this.baseUrl}/me/friends`,
            { headers: this.authService.getSessionIdHeaders() }
        );
    }

    getUserFriendStatus(username: string) {
        if (username == this.userInfoService.user.username)
            return of(FriendStatus.Self);
        return combineLatest([
            this.friendsObservable,
            this.sentRequestsObservable,
            this.receivedRequestsObservable,
        ]).pipe(map(
            ([friends, sent, received]) => this.filterUserStatus(username, friends, sent, received)
        ));
    }

    sendFriendRequest(username: string) {
        this.http.post(
            `${this.baseUrl}/me/friends/requests/${username}`, {},
            { headers: this.authService.getSessionIdHeaders() }
        ).subscribe(() => this.refreshSentRequests());
    }

    deleteFriendRequest(username: string) {
        this.http.delete(
            `${this.baseUrl}/me/friends/requests/${username}`,
            { headers: this.authService.getSessionIdHeaders() }
        ).subscribe(() => this.refreshSentRequests());
    }

    answerFriendRequest(requestId: string, answer: boolean) {
        this.http.post(
            `${this.baseUrl}/me/friends/requests/answer/${requestId}`, { answer },
            { headers: this.authService.getSessionIdHeaders() }
        ).subscribe(() => this.refreshReceivedRequest());
    }

    answerFriendRequestByUsername(username: string, answer: boolean) {
        let request = this.receivedRequestsSubject.getValue().find((request) => request.senderUsername === username)
        if (!request) throw new Error('invalid username');

        this.answerFriendRequest(request.id, answer);
    }

    sawFriendRequest(requestId: string) {
        this.socketService.emit('friend-socket:seenRequest', requestId);
    }

    removeFriend(username: string) {
        return this.http.delete(
            `${this.baseUrl}/me/friends/${username}`, { headers: this.authService.getSessionIdHeaders() }
        ).subscribe(() => this.refreshFriends());
    }

    private init() {
        this.socketService.on('friend-socket:receivedRequest', this.boundHandlers.receivedRequest);
        this.socketService.on('friend-socket:removedRequest', this.boundHandlers.removedRequest);
        this.socketService.on('friend-socket:acceptedRequest', this.boundHandlers.acceptedRequest);
        this.socketService.on('friend-socket:removedFriend', this.boundHandlers.removedFriend);
        this.socketService.on('friend-socket:addedFriend', this.boundHandlers.addedFriend);
        this.socketService.on('friend-socket:requestUpdated', this.boundHandlers.requestUpdated);
        this.socketService.on('friend-socket:relationUpdated', this.boundHandlers.relationUpdated);

        this.socketService.emit('friend-socket:join', this.authService.getSessionId());

        this.refreshFriends();
        this.refreshSentRequests();
        this.refreshReceivedRequestsOnLogIn();
    }

    private destroy() {
        this.socketService.off('friend-socket:receivedRequest', this.boundHandlers.receivedRequest);
        this.socketService.off('friend-socket:removedRequest', this.boundHandlers.removedRequest);
        this.socketService.off('friend-socket:acceptedRequest', this.boundHandlers.acceptedRequest);
        this.socketService.off('friend-socket:removedFriend', this.boundHandlers.removedFriend);
        this.socketService.off('friend-socket:addedFriend', this.boundHandlers.addedFriend);
        this.socketService.off('friend-socket:requestUpdated', this.boundHandlers.requestUpdated);
        this.socketService.off('friend-socket:relationUpdated', this.boundHandlers.relationUpdated);
    }

    private refreshFriends() {
        this.getFriends().subscribe((friends) => this.friendsSubject.next(friends));
    }

    private requestUpdated() {
        this.refreshReceivedRequest();
        this.refreshSentRequests();
    }

    private getSentFriendRequests(): Observable<FriendRequest[]> {
        return this.http.get<FriendRequest[]>(
            `${this.baseUrl}/me/friends/requests/sent`,
            { headers: this.authService.getSessionIdHeaders() }
        );
    }

    private getReceivedFriendRequests(): Observable<FriendRequest[]> {
        return this.http.get<FriendRequest[]>(
            `${this.baseUrl}/me/friends/requests/received`,
            { headers: this.authService.getSessionIdHeaders() }
        );
    }

    private refreshSentRequests() {
        this.getSentFriendRequests().subscribe((requests) => this.sentRequestsSubject.next(requests));
    }

    private refreshReceivedRequest() {
        this.getReceivedFriendRequests().subscribe((requests) => this.receivedRequestsSubject.next(requests));
    }

    private refreshReceivedRequestsOnLogIn() {
        this.getReceivedFriendRequests().subscribe((requests) => {
            this.receivedRequestsSubject.next(requests);
            const unseenRequests = requests.filter((request) => !request.seen);
            this.showUnseenRequestsNotification(unseenRequests);
        });
    }

    private friendAdded(username: string) {
        const currentFriends = this.friendsSubject.value;
        this.friendsSubject.next([...currentFriends, username]);
    }

    private friendRemoved(username: string) {
        const currentFriends = this.friendsSubject.value;
        this.friendsSubject.next(currentFriends.filter(friendUsername => friendUsername !== username));
        this.chatsService.cleanupFriendOnlyChats(username);
    }

    private addReceivedRequest(request: FriendRequest) {
        const currentRequests = this.receivedRequestsSubject.value;
        this.receivedRequestsSubject.next([...currentRequests, request]);

        this.audioService.playSound(NOTIFICATION_SOUND_MP3);
        
        this.showFriendRequestNotification(request);
        this.sawFriendRequest(request.id);
    }

    private removeReceivedRequest(removedRequest: FriendRequest) {
        const currentRequests = this.receivedRequestsSubject.value;
        this.receivedRequestsSubject.next(currentRequests.filter(request => request.senderUsername !== removedRequest.senderUsername));
    }

    private onAcceptedRequest(response: { accepterUsername: string, answer: boolean }) {
        const currentRequests = this.sentRequestsSubject.value;
        this.sentRequestsSubject.next(currentRequests.filter(request => request.receiverUsername !== response.accepterUsername));

        if (!response.answer) return;

        const message = this.translate.instant('FriendRequests.RequestAccepted', { username: response.accepterUsername });
        const data = { message, icon: 'how_to_reg' };
        
        this.audioService.playSound(NOTIFICATION_SOUND_MP3);

        this.dialogModalService.openNotification(NotificationComponent, data);
    }

    private filterUserStatus(username: string, friends: string[], sent: FriendRequest[], received: FriendRequest[]) {
        let friendsSet = new Set(friends);
        if (friendsSet.has(username)) return FriendStatus.Friend;

        let sentSet = new Set(sent.map((sent) => sent.receiverUsername));
        if (sentSet.has(username)) return FriendStatus.SentRequest;

        let receivedSet = new Set(received.map((received) => received.senderUsername));

        if (receivedSet.has(username)) return FriendStatus.ReceivedRequest;
        return FriendStatus.None;
    }

    private showFriendRequestNotification(request: FriendRequest) {
        const message = this.translate.instant('FriendRequests.NewRequestFrom', { username: request.senderUsername });

        const data = { message, icon: 'person_add' };
        this.dialogModalService.openNotification(NotificationComponent, data);
    }

    private showUnseenRequestsNotification(unseenRequests: FriendRequest[]) {
        if (!unseenRequests.length) return;

        const data = {
            message: this.translate.instant('FriendRequests.MultipleRequests', { count: unseenRequests.length }),
            icon: 'group_add',
            arrowCallback: () => this.privateProfile.goToPage('friends'),
        };

        this.dialogModalService.openNotification(NotificationComponent, data);
        unseenRequests.forEach((request) => this.sawFriendRequest(request.id));
    }
}
