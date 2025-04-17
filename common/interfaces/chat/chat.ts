import { ChatMessage } from './chat-message';

export interface Chat {
    id: string;
    name: string;
    creatorUsername: string;
    messages: ChatMessage[];
    isFriendsOnly: boolean;
}
