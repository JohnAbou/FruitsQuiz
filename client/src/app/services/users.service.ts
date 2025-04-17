import { HttpClient, } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { BehaviorSubject, combineLatest, map, of } from 'rxjs';
import { FriendsService } from './friends.service';
import { SocketFactoryService } from './socket-service/socket-factory.service';
import { User } from '@app/interfaces/user';
import { UserInfoService } from './user-info.service';

@Injectable({
    providedIn: 'root',
})
export class UsersService {
    usernameModifiedEvent: EventEmitter<UsernameModifiedEvent> = new EventEmitter();
    avatarModifiedEvent: EventEmitter<AvatarModifiedEvent> = new EventEmitter();

    private readonly usersSubject: BehaviorSubject<User[]> = new BehaviorSubject<User[]>([]);

    // Observable are so cute tbh
    get filteredUsersObservable() {
        return combineLatest([
            this.usersSubject.asObservable(),
            this.friendsService.friendsObservable,
            this.userService.userObservable.pipe(map(user => user.username)),
        ]).pipe(
            map(([users, friends, username]) => this.filterUsers(users, friends, username))
        );
    }

    constructor(
        private readonly httpClient: HttpClient,
        private readonly friendsService: FriendsService,
        private readonly userService: UserInfoService,
        factory: SocketFactoryService
    ) {
        const socket = factory.getSocket();
        socket.on('users-socket:newUserRegistered', this.newUserRegistered.bind(this));
        socket.on('usernameModified', this.usernameUpdated.bind(this));
        socket.on('avatarModified', this.avatarUpdated.bind(this));

        this.loadUsers();
    }

    getUserInfo(id: string) {
        if (!id) return of(null);

        return this.usersSubject.pipe(
            map(users => users.find(user => user.id === id) ?? defaultUser)
        );
    }

    getUserByUsername(username: string) {
        return this.usersSubject.value.find((user) => user.username === username);
    }

    private newUserRegistered(user: User) {
        this.usersSubject.next([... this.usersSubject.getValue(), user]);
    }

    private usernameUpdated(event: UsernameModifiedEvent) {
        const users = this.usersSubject.getValue();
        const userIndex = users.findIndex(user => user.username === event.oldUsername);
        if (userIndex === -1) return;

        const newUsers = [...users];
        newUsers[userIndex] = { ...newUsers[userIndex], username: event.newUsername };
        this.usersSubject.next(newUsers);
        this.usernameModifiedEvent.emit(event);
    }

    private avatarUpdated(event: AvatarModifiedEvent) {
        const users = this.usersSubject.getValue();
        const userIndex = users.findIndex(user => user.username === event.username);
        if (userIndex === -1) return;

        const newUsers = [...users];
        newUsers[userIndex] = { ...newUsers[userIndex], activeAvatarId: event.newAvatar };
        this.usersSubject.next(newUsers);
        this.avatarModifiedEvent.emit(event);
    }

    private loadUsers() {
        this.httpClient.get<User[]>(`${environment.serverUrl}/accounts/`, {
            observe: 'body', responseType: 'json',
        }).subscribe((users) => (this.usersSubject.next(users)));
    }

    private filterUsers(users: User[], friends: string[], username: string) {
        const friendSet = new Set([...friends, username]);

        return users.filter(user => !friendSet.has(user.username));
    }
}

export interface UsernameModifiedEvent { oldUsername: string, newUsername: string }
export interface AvatarModifiedEvent { username: string, newAvatar: string }

const defaultUser: User = {
    id: '',
    username: '',
    email: '',
    avatarIds: [],
    activeAvatarId: '',
}
