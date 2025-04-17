import { Service } from "typedi";
import { FriendRequestsDataManager } from "../data/friend-requests-data-manager";
import { FriendsSocketService } from "../sockets/friends-socket.service";
import { randomUUID } from "crypto";
import { FriendRelationsDataManager } from "../data/friend-relations-data-manager";
import { UsernameModificationService } from "./username-modification.service";
import { UsernameModifiedEvent } from "@app/interfaces/users/username-modified-event";

@Service()
export class FriendsManagerService {
    constructor(
        private readonly friendRequestsDataManager: FriendRequestsDataManager,
        private readonly friendRelationsDataManager: FriendRelationsDataManager,
        private readonly friendsSocketService: FriendsSocketService,
        private readonly usernameModificationService: UsernameModificationService,
    ) {
        this.initialize();
        this.usernameModificationService.usernameModifiedEvent
            .subscribe((event) => this.onUsernameChanged(event));
    }

    async getSentRequest(senderUsername: string) {
        return this.friendRequestsDataManager.getUserSentRequest(senderUsername);
    }

    async getReceivedRequest(receiverUsername: string) {
        return this.friendRequestsDataManager.getUserReceivedRequest(receiverUsername);
    }

    async getUserFriends(username: string) {
        return this.friendRelationsDataManager.getUserFriends(username);
    }

    async onFriendRequestSeen(requestId: string) {
        this.friendRequestsDataManager.updateFriendRequestSeen(requestId);
    }

    async addFrientRequest(senderUsername: string, receiverUsername: string) {
        const request = { senderUsername, receiverUsername, seen: false, id: randomUUID() };
        const result = await this.friendRequestsDataManager.addFriendRequest(request);
        if (result) {
            this.friendsSocketService.notifyUserOfNewRequest(request);
        }
        return result;
    }

    async deleteFriendRequest(senderUsername: string, receiverUsername: string) {
        const result = this.friendRequestsDataManager.deleteFriendRequest(senderUsername, receiverUsername);
        if (result) {
            this.friendsSocketService.notifyUserOfRemovedRequest({ senderUsername, receiverUsername, seen: false, id: '0' }, receiverUsername);
        }
        return result;
    }

    async answerFriendRequest(accepterUsername: string, answer: boolean, friendRequestId: string): Promise<boolean> {
        const request = await this.friendRequestsDataManager.deleteFriendRequestedById(friendRequestId);
        if (!request || accepterUsername !== request.receiverUsername) return false;

        this.friendsSocketService.notifyUserOfRemovedRequest(request, request.senderUsername);
        this.friendsSocketService.notifyUserOfRequestAnswered(accepterUsername, request.senderUsername, answer);
        if (!answer) return true;

        this.friendsSocketService.notifyUsersOfNewFriendShip(accepterUsername, request.senderUsername);
        this.friendRelationsDataManager.addFriendRelation({ username1: request.receiverUsername, username2: request.senderUsername });
        return true;
    }

    async deleteFriendRelation(username1: string, username2: string) {
        const result = await this.friendRelationsDataManager.delateFriendRelation(username1, username2);
        if (!result) return;
        this.friendsSocketService.notifyUserOfDeletedFriendShip(username1, username2);
    }

    private initialize() {
        this.friendsSocketService.friendRequestSeen.subscribe((requestId) => this.onFriendRequestSeen(requestId));
    }

    private async onUsernameChanged(event: UsernameModifiedEvent) {
        const requestUpdated = await this.friendRequestsDataManager.renameFriendRequest(event);
        if (requestUpdated) this.friendsSocketService.notifyOfRequestUpdated();

        const relationUpdated = await this.friendRelationsDataManager.renameUser(event);
        if (relationUpdated) this.friendsSocketService.notifyOfRelationUpdated();
    }
}