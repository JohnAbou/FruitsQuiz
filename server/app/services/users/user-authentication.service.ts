import { Service } from 'typedi';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { USER_COLLECTION } from '@app/consts/database.consts';
import { UsersSessionsService } from './user-sessions.service';
import { comparePassword, hashPassword } from '@app/utils/hashing.utils';
import { AccountResponse, UserPreferences } from '@common/interfaces/response/account-response';
import { randomUUID } from 'crypto';
import { validateEmail, validatePassword, validateUsername } from '@app/utils/account-validation';
import * as i18next from 'i18next';
import { UsersSocket } from '../sockets/users-socket.service';
import { User } from '@app/interfaces/users/user';
import { UsernameModificationService } from './username-modification.service';
import { UsersStatsService } from './user-stats-service';
import { createUserChat } from '@app/utils/default-user-chat.utils';

@Service()
export class UserAuthenticationService {
    private i18n: i18next.i18n;

    constructor(
        private dataManagerService: DataManagerService<User>,
        private userModificationService: UsernameModificationService,
        private userStatsService: UsersStatsService,
        private usersSessionService: UsersSessionsService,
        private usersSocketService: UsersSocket,
    ) {
        this.dataManagerService.setCollection(USER_COLLECTION);
    }

    public setI18nInstance(i18n: i18next.i18n): void {
        this.i18n = i18n;
    }

    validateAccount(username: string, email: string, password: string) {
        return {
            usernameError: validateUsername(username, this.i18n.t.bind(this.i18n)),
            emailError: validateEmail(email, this.i18n.t.bind(this.i18n)),
            passwordError: validatePassword(password, this.i18n.t.bind(this.i18n)),
        };
    }

    async signup(username: string, email: string, password: string, avatar: string): Promise<AccountResponse> {
        const response: AccountResponse = {};

        const hashedPassword = await hashPassword(password);
        const user: User = this.createDefaultUser(username, email, hashedPassword, avatar);

        const users = await this.dataManagerService.getElements();
        for (const existingUser of users) {
            if (existingUser.username.toLowerCase() === username.toLowerCase())
                response.usernameError = 'AccountValidation.UsernameTaken';
            if (existingUser.email.toLowerCase() === email.toLowerCase()) response.emailError = 'AccountValidation.EmailTaken';
        }

        if (response.usernameError || response.emailError || response.passwordError) return response;

        await this.dataManagerService.addElement(user);
        this.userStatsService.initializeUserStats(user.id);

        this.usersSocketService.emitNewUserRegistered(user);
        return {
            sessionId: this.usersSessionService.createUserSession(user.id),
            preferences: this.getUserPreferences(user),
        };
    }

    async login(username: string, password: string): Promise<{ sessionId?: string; preferences?: UserPreferences; error?: string }> {
        if (!username || !password) return { error: 'AccountValidation.MissingFields' };

        const users = await this.dataManagerService.getElements();

        for (const user of users) {
            if (user.username !== username || !(await comparePassword(password, user.hashedPassword))) continue;
            const sessionId = this.usersSessionService.createUserSession(user.id);
            const preferences = this.getUserPreferences(user);
            return sessionId ? { sessionId, preferences } : { error: 'AccountValidation.AlreadyLoggedIn' };
        }
        return { error: 'AccountValidation.IncorrectCredentials' };
    }

    async updateUsername(username: string, newUsername: string): Promise<{ success: boolean; error?: string }> {
        let usernameError = validateUsername(newUsername, this.i18n.t.bind(this.i18n));
        if (usernameError) {
            return { success: false, error: usernameError };
        }
    
        const users = await this.dataManagerService.getElements();
        for (const existingUser of users) {
            if (existingUser.username.toLowerCase() === newUsername.toLowerCase()) {
                return { success: false, error: 'AccountValidation.UsernameTaken' };
            }
        }
    
        const success = await this.userModificationService.changeUsername(username, newUsername);
        return { success };
    }
    

    private getUserPreferences(user: User): UserPreferences {
        return {
            language: (user as any).language ?? 'fr',
            background: (user as any).background ?? 'none',
            theme: (user as any).theme ?? 'lemon-theme',
        };
    }

    private createDefaultUser(username: string, email: string, hashedPassword: string, avatarId?: string): User {
        const fallbackAvatarId = 'avatar1';
        const selectedAvatarId = avatarId || fallbackAvatarId;

        return {
            id: randomUUID(),
            username,
            email,
            hashedPassword,
            chats: [createUserChat('1')],
            activeAvatarId: selectedAvatarId,
            avatarIds: [
                'avatar1',
                'avatar2',
                'avatar3',
                'avatar4',
                'avatar5',
                'avatar6',
                'avatar7',
                'avatar8',
                'avatar9',
                'avatar10',
                'avatar11',
                'avatar12',
            ],
            currency: 0,
            language: 'fr',
            background: 'none',
            theme: 'lemon-theme',
        } as User;
    }
}
