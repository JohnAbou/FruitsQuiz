import { ChatMessage } from './chat-message';

export interface UserActionMessage extends ChatMessage {
    affectedUser: string;
    action: UserAction;
}

export enum UserAction {
    Joined = 'joined',
    Left = 'left',
}
