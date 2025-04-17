import { Component, OnInit } from '@angular/core';
import { UsersService } from '@app/services/users.service';
import { FormControl } from '@angular/forms';
import { combineLatest, Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { Router } from '@angular/router';
import { User } from '@app/interfaces/user';

@Component({
	selector: 'app-users-list-page',
	templateUrl: './users-list-page.component.html',
	styleUrls: ['./users-list-page.component.scss']
})
export class UsersListPageComponent implements OnInit {
	usernameFilter = new FormControl('');
	filteredUsers: Observable<User[]>;

	constructor(
		private readonly usersService: UsersService,
		private readonly router: Router,
	) { }

	ngOnInit(): void {
		this.filteredUsers = combineLatest([
			this.usersService.filteredUsersObservable,
			this.usernameFilter.valueChanges.pipe(startWith('')),
		]).pipe(
			map(([users, filter]) => users.filter(
				(user) => user.username.toLowerCase().includes(filter ?? ''))
			)
		);
	}

	navigateToProfile(id: string): void {
		this.router.navigate(['/real-public-profile', id]);
	}
}