import { Component } from '@angular/core';
import { FriendsService } from '@app/services/friends.service';
import { UsersService } from '@app/services/users.service';

@Component({
	selector: 'app-friends-list',
	templateUrl: './friends-list.component.html',
	styleUrls: ['./friends-list.component.scss']
})
export class FriendsListComponent {

	get friends() {
		return this.friendsService.friendsObservable;
	}

	getFriendUser(username: string) {
		return this.userService.getUserByUsername(username);
	}

	constructor(
		private friendsService: FriendsService,
		private userService: UsersService,
	) { }

	removeFriend(username: string): void {
		this.friendsService.removeFriend(username);
	}
}
