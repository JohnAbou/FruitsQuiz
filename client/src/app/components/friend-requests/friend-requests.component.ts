import { Component } from '@angular/core';
import { FriendsService } from '@app/services/friends.service';
import { UsersService } from '@app/services/users.service';
@Component({
	selector: 'app-friend-requests',
	templateUrl: './friend-requests.component.html',
	styleUrls: ['./friend-requests.component.scss']
})
export class FriendRequestsComponent {
	activeTab = 'received';

	get receivedRequest() {
		return this.friendRequestsService.receivedRequestsObservable;
	}

	get sentRequest() {
		return this.friendRequestsService.sentRequestsObservable;
	}

	constructor(
		private friendRequestsService: FriendsService,
		private userService: UsersService
	) { }

	getFriendUser(username: string) {
		return this.userService.getUserByUsername(username);
	}

	deleteRequest(username: string) {
		this.friendRequestsService.deleteFriendRequest(username);
	}

	answerRequest(requestId: string, answer: boolean): void {
		this.friendRequestsService.answerFriendRequest(requestId, answer);
	}
}