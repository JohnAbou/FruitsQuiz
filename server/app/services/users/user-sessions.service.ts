import { Service } from 'typedi';
import { randomUUID } from 'crypto';
import { UserDataManager } from '../data/user-data-manager.service';

@Service()
export class UsersSessionsService {
    private sessions = new Map<string, string>();

    constructor(private readonly userDataManager: UserDataManager) {}

    createUserSession(userId: string): string {
        if (this.isUserInAnySession(userId)) return '';

        const sessionId = randomUUID();
        this.sessions.set(sessionId, userId);
        return sessionId;
    }

    closeUserSession(sessionId: string): void {
        this.sessions.delete(sessionId);
    }

    async getUser(sessionId: string) {
        return await this.userDataManager.getElementById(this.getUserIdFromSession(sessionId));
    }

    getUserIdFromSession(sessionId: string): string | undefined {
        return this.sessions.get(sessionId);
    }


    private isUserInAnySession(userId: string): boolean {
        return [...this.sessions.values()].some((sessionUserId) => sessionUserId === userId);
    }
}
