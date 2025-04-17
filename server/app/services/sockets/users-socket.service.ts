import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { User } from '@app/interfaces/users/user';

@Service()
export class UsersSocket extends BaseSocketHandler {
    emitNewUserRegistered(user: User) {
        delete user.hashedPassword;
        this.socketManager.emit('users-socket:newUserRegistered', user);
    }
}
