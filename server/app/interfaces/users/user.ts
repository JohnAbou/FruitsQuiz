export interface User {
    id: string;
    username: string;
    email: string;
    hashedPassword: string;
    chats: UserChat[];
    avatarIds: string[];
    activeAvatarId: string;
}

export interface UserChat {
    id: string;
    nUnreadMessages: number;
}
