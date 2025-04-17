import { UserChat } from '@app/interfaces/users/user';

export const createUserChat = (id: string): UserChat => {
    return {
        id: id,
        nUnreadMessages: 0,
    };
};
