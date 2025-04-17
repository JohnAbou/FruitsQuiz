import { Component, Input, OnChanges } from '@angular/core';
import { Router } from '@angular/router';
import { UsersService } from '@app/services/users.service';

@Component({
  selector: 'app-profile-icon',
  templateUrl: './profile-icon.component.html',
  styleUrls: ['./profile-icon.component.scss']
})
export class ProfileIconComponent implements OnChanges {
  @Input() username = "";
  @Input() id = "";

  constructor(
    private readonly router: Router,
    private readonly usersService: UsersService,
  ) { }

  ngOnChanges(): void {
    if (!this.id || this.id === "")
    this.id = this.usersService.getUserByUsername(this.username)?.id ?? "";
  }

  navigateToProfile(): void {
    this.router.navigate(['/real-public-profile', this.id]);
  }
}
