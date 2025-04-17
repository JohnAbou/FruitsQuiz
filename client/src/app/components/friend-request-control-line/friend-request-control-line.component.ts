import { Component, Input, SimpleChanges } from '@angular/core';
import { FriendStatus } from '@app/enums/friend-status.enum';
import { FriendsService } from '@app/services/friends.service';
import { Observable } from 'rxjs';


@Component({
	selector: 'app-friend-request-control-line',
	templateUrl: './friend-request-control-line.component.html',
	styleUrls: ['./friend-request-control-line.component.scss']
})
export class FriendRequestControlLineComponent {
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
