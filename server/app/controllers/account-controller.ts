import { Service } from 'typedi';
import { Request, Response } from 'express';
import { getUserMiddleware, RequestWithUser } from '@app/middlewares/user-required-middleware';
import { BaseController } from './base-controller';
import { UserLevelManager } from '@app/services/users/user-level-manager.service';
import { UserAuthenticationService } from '@app/services/users/user-authentication.service';
import { StatusCodes } from 'http-status-codes';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { USER_COLLECTION } from '@app/consts/database.consts';
import { FriendsManagerService } from '@app/services/users/friends-manager.service';
import { ImageService } from '@app/services/image/image.service';
import * as multer from 'multer';
import { User } from '@app/interfaces/users/user';
import { GameHistoryService } from '@app/services/game/game-history.service';
import { UsersStatsService } from '@app/services/users/user-stats-service';
import { AuthenticationLogService } from '@app/services/users/user-authentication-log.service';
import { UsernameModificationService } from '@app/services/users/username-modification.service';

const upload = multer({ storage: multer.memoryStorage() });

@Service()
export class AccountController extends BaseController {
    constructor(
        private userLevelManager: UserLevelManager,
        private userAuthService: UserAuthenticationService,
        private dataManager: DataManagerService<User>,
        private friendsManager: FriendsManagerService,
        private imageService: ImageService,
        private gameLoggingService: GameHistoryService,
        private userStatsService: UsersStatsService,
        private authenticationLogService: AuthenticationLogService,
        private userModifiedService: UsernameModificationService,
    ) {
        super();
        this.dataManager.setCollection(USER_COLLECTION);
    }

    protected configureRouter(): void {
        this.router.get('/', this.getUsersInfo.bind(this));
        this.router.get('/me', getUserMiddleware, this.getMyUserInfo.bind(this));
        this.router.get('/:username', this.getUserInfo.bind(this));
        this.router.post('/login', this.login.bind(this));
        this.router.post('/register', this.register.bind(this));
        this.router.get('/me/exp-info', getUserMiddleware, this.getUserExperienceInfo.bind(this));
        this.router.get('/id/:id/exp-info', this.getUserExperienceInfoById.bind(this));
        this.router.put('/me/username', getUserMiddleware, this.updateUsername.bind(this));
        this.router.get('/me/stats', getUserMiddleware, this.getUserStats.bind(this));

        // Avatar related routes
        this.router.post('/me/avatar/select', getUserMiddleware, this.setUserAvatar.bind(this));
        this.router.post('/me/avatar/upload', upload.single('image'), getUserMiddleware, this.uploadAvatar.bind(this));

        // Friends related routes
        this.router.get('/me/friends', getUserMiddleware, this.getUserFriends.bind(this));
        this.router.delete('/me/friends/:username', getUserMiddleware, this.deleteFriendRelation.bind(this));
        this.router.post('/me/friends/requests/answer/:requestId', getUserMiddleware, this.answerFriendRequest.bind(this));
        this.router.post('/me/friends/requests/:username', getUserMiddleware, this.postFriendRequest.bind(this));
        this.router.delete('/me/friends/requests/:username', getUserMiddleware, this.deleteFriendRequest.bind(this));
        this.router.get('/me/friends/requests/sent', getUserMiddleware, this.getSentFriendRequests.bind(this));
        this.router.get('/me/friends/requests/received', getUserMiddleware, this.getReceivedFriendRequests.bind(this));
    
        // Stats & history related routes
        this.router.get('/me/game-logs', getUserMiddleware, this.getGameLogs.bind(this));
        this.router.get('/stats/all', this.getAllGameStats.bind(this));
        this.router.get('/stats/:id', this.getGameStats.bind(this));

        // authentication with new middleware
        this.router.get('/me/authentication-logs', getUserMiddleware, this.getAuthenticationLogs.bind(this));
    }

    private async login(request: Request, response: Response) {
        const { username, password } = request.body;
        const result = await this.userAuthService.login(username, password);
        response.status(result.sessionId ? StatusCodes.OK : StatusCodes.FORBIDDEN).json(result);
    }

    private async register(request: Request, response: Response) {
        const { username, password, email, avatar } = request.body;
        const validation = this.userAuthService.validateAccount(username, email, password);
        if (validation.emailError || validation.passwordError || validation.usernameError) {
            response.status(StatusCodes.FORBIDDEN).json(validation);
            return;
        }
        const result = await this.userAuthService.signup(username, email, password, avatar);
        response.status(result.sessionId ? StatusCodes.OK : StatusCodes.FORBIDDEN).json(result);
    }

    private async getMyUserInfo(request: RequestWithUser, response: Response) {
        const username = request.user.username;
        this.getUserInfoIntern(username, response);
    }

    private async getUserInfo(request: Request, response: Response) {
        const username = request.params.username;
        this.getUserInfoIntern(username, response);
    }

    private async getUserInfoIntern(username: string, response: Response) {
        await this.attemptOperation(response, async () => {
            const element = await this.dataManager.getElementByUsername(username);
            if (!element) {
                response.status(StatusCodes.NOT_FOUND).send();
            } else {
                delete element.hashedPassword;
                response.status(StatusCodes.OK).json(element);
            }
        });
    }

    private async getUsersInfo(request: Request, response: Response) {
        await this.attemptOperation(response, async () => {
            const elements = await this.dataManager.getElements();
            if (!elements) {
                response.status(StatusCodes.NOT_FOUND).send();
            } else {
                elements.forEach((element) => delete element.hashedPassword);
                response.status(StatusCodes.OK).json(elements);
            }
        });
    }

    private async getUserExperienceInfo(request: RequestWithUser, response: Response) {
        const username = request.user.username;
        const userExperienceInfo = await this.userLevelManager.getUserExperienceInfo(username);
        response.json(userExperienceInfo);
    }

    // Friend related methods
    private async getUserFriends(request: RequestWithUser, response: Response) {
        this.attemptOperation(response, async () => {
            const result = await this.friendsManager.getUserFriends(request.user.username);
            response.status(StatusCodes.OK).json(result);
        });
    }

    

    private async deleteFriendRelation(request: RequestWithUser, response: Response) {
        const username1 = request.user.username;
        const username2 = request.params.username;
        this.attemptOperation(response, async () => {
            await this.friendsManager.deleteFriendRelation(username1, username2);
            response.status(StatusCodes.NO_CONTENT).send();
        });
    }

    private async answerFriendRequest(request: RequestWithUser, response: Response) {
        const requestId = request.params.requestId;
        const answer = request.body.answer;
        this.attemptOperation(response, async () => {
            const result = await this.friendsManager.answerFriendRequest(request.user.username, answer, requestId);
            response.status(result ? StatusCodes.OK : StatusCodes.BAD_REQUEST).send();
        });
    }

    private async postFriendRequest(request: RequestWithUser, response: Response) {
        const senderUsername = request.user.username;
        const receiverUsername = request.params.username;
        this.attemptOperation(response, async () => {
            const result = await this.friendsManager.addFrientRequest(senderUsername, receiverUsername);
            response.status(result ? StatusCodes.OK : StatusCodes.BAD_REQUEST).send();
        });
    }

    private async deleteFriendRequest(request: RequestWithUser, response: Response) {
        const senderUsername = request.user.username;
        const receiverUsername = request.params.username;
        this.attemptOperation(response, async () => {
            const result = await this.friendsManager.deleteFriendRequest(senderUsername, receiverUsername);
            response.status(result ? StatusCodes.OK : StatusCodes.NOT_FOUND).send();
        });
    }

    private async getSentFriendRequests(request: RequestWithUser, response: Response) {
        const username = request.user.username;
        this.attemptOperation(response, async () => {
            const requests = await this.friendsManager.getSentRequest(username);
            response.status(StatusCodes.OK).json(requests);
        });
    }

    private async getReceivedFriendRequests(request: RequestWithUser, response: Response) {
        const username = request.user.username;
        this.attemptOperation(response, async () => {
            const requests = await this.friendsManager.getReceivedRequest(username);
            response.status(StatusCodes.OK).json(requests);
        });
    }

    private async updateUsername(request: RequestWithUser, response: Response): Promise<Response> {
        const username = request.user.username;
        const { newUsername } = request.body;
        await this.attemptOperation(response, async () => {
            const result = await this.userAuthService.updateUsername(username, newUsername);
            if (result.success) {
                response.status(StatusCodes.OK).json({ success: true, newUsername });
            } else {
                response.status(StatusCodes.CONFLICT).json({ error: result.error });
            }
        });
        return response;
    }
    

    private async setUserAvatar(request: RequestWithUser, response: Response): Promise<Response> {
        const { avatarUrl } = request.body;
        const user = request.user;
        const parsedAvatarId = avatarUrl.split('/').pop()?.replace('.png', '');
        if (!parsedAvatarId) { // why bother checking server side when we can let the client do it? || !user.avatarIds.includes(parsedAvatarId)
            return response.status(StatusCodes.FORBIDDEN).json({ error: 'Avatar non valide' });
        }
        const updated = await this.userModifiedService.selectAvatar(user.id, user.username, parsedAvatarId); 
        if (!updated) {
            return response.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Impossible de mettre à jour l’avatar' });
        }
        return response.json({ message: 'Avatar mis à jour', avatarId: avatarUrl });
    }

    private async uploadAvatar(request: RequestWithUser, response: Response): Promise<Response> {
        if (!request.file) {
            return response.status(StatusCodes.BAD_REQUEST).json({ error: 'Aucun fichier fourni' });
        }
        const avatarId = await this.imageService.processAvatarImage(request.file.buffer);
        if (!avatarId) {
            return response.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Erreur lors du traitement de l’image' });
        }
        await this.userModifiedService.selectAvatar(request.user.id, request.user.username, avatarId);
        return response.json({ avatarId });
    }

    private async getAuthenticationLogs(request: RequestWithUser, response: Response) {
        this.attemptOperation(response, async () => {
            response.status(StatusCodes.OK).json(await this.authenticationLogService.getAuthenticationLog(request.user.id));
        });
    }

    private async getGameLogs(request: RequestWithUser, response: Response) {
        this.attemptOperation(response, async () => {
            response.status(StatusCodes.OK).json(await this.gameLoggingService.getUserHistory(request.user.id));
        });
    }

    private async getGameStats(request: Request, response: Response) {
        const id = request.params.id;
        if (!id) return response.send(StatusCodes.BAD_REQUEST);

        return this.attemptOperation(response, async () => {
            response.status(StatusCodes.OK).json(await this.userStatsService.getUserStats(id));
        });
    }

    private async getAllGameStats(request: Request, response: Response) {
        return this.attemptOperation(response, async () => {
            response.status(StatusCodes.OK).json(await this.userStatsService.getUsersStats());
        });
    }

    private async getUserExperienceInfoById(request: Request, response: Response) {
        const id = request.params.id;
        await this.attemptOperation(response, async () => {
            const user = await this.dataManager.getElementById(id);
            if (!user) {
                response.status(StatusCodes.NOT_FOUND).json({ error: 'User not found' });
                return;
            }
            const userExperienceInfo = await this.userLevelManager.getUserExperienceInfo(user.username);
            response.status(StatusCodes.OK).json(userExperienceInfo);
        });
    }
    
    private async getUserStats(request: RequestWithUser, response: Response){
        const id = request.user.id;
        const userStats = await this.userStatsService.getUserStats(id);
        response.json(userStats);
    }
    
}
