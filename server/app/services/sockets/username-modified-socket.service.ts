import { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { UsernameModifiedEvent } from '@app/interfaces/users/username-modified-event';
import { AvatarModifiedEvent } from '@app/interfaces/users/avatar-modified-event';

@Service()
export class UsernameModifiedSocket extends BaseSocketHandler {
    emitUsernameChangedNotification(usernameChangedEvent: UsernameModifiedEvent) {
        this.socketManager.emit('usernameModified', usernameChangedEvent);
    }

    emitAvatarChangedNotification(avatarChangedEvent: AvatarModifiedEvent) {
        this.socketManager.emit('avatarModified', avatarChangedEvent);
    }
}
