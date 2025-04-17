import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { FriendStatus } from '@app/enums/friend-status.enum';
import { FriendsService } from '@app/services/friends.service';
import { Observable } from 'rxjs';

@Component({
	selector: 'app-friend-request-control',
	templateUrl: './friend-request-control.component.html',
	styleUrls: ['./friend-request-control.component.scss']
})
export class FriendRequestControlComponent implements OnChanges {
	@Input() username: string;
	friendStatusObservable?: Observable<FriendStatus>;

	constructor(private readonly friendsService: FriendsService) { }

	ngOnChanges(changes: SimpleChanges): void {
		this.friendStatusObservable = this.friendsService.getUserFriendStatus(this.username);
	}

	sendRequest() {
		this.friendsService.sendFriendRequest(this.username);
	}

	deleteRequest() {
		this.friendsService.deleteFriendRequest(this.username);
	}

	answerRequest(answer: boolean) {
		this.friendsService.answerFriendRequestByUsername(this.username, answer);
	}

	removeFriend() {
		this.friendsService.removeFriend(this.username);
	}
}
