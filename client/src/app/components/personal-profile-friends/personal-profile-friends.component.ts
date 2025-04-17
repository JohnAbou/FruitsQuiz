import { Component } from '@angular/core';
import { FriendsService } from '@app/services/friends.service';

@Component({
  selector: 'app-personal-profile-friends',
  templateUrl: './personal-profile-friends.component.html',
  styleUrls: ['./personal-profile-friends.component.scss']
})
export class PersonalProfileFriendsComponent {
  constructor(private readonly friendsService: FriendsService) { }

  sendRequest(username: string): void {
    this.friendsService.sendFriendRequest(username);
  }
}
