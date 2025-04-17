import { Request, Response, NextFunction } from 'express';
import { createUnsuccessfulResponse } from '@app/utils/responses.utils';
import { Container } from 'typedi';
import { UsersSessionsService } from '@app/services/users/user-sessions.service';
import { StatusCodes } from 'http-status-codes';
import { User } from '@app/interfaces/users/user';

export interface RequestWithUser extends Request {
    user?: User;
}

export async function getUserMiddleware(req: RequestWithUser, res: Response, next: NextFunction) {
    try {
        const sessionId = req.headers['x-session-id'] as string;

        if (!sessionId) {
            return res.status(StatusCodes.BAD_REQUEST).json(createUnsuccessfulResponse(-1));
        }

        const userSessionsService = Container.get(UsersSessionsService);
        const user = await userSessionsService.getUser(sessionId);
        if (!user) return res.status(StatusCodes.NOT_FOUND).json(createUnsuccessfulResponse(-1));

        req.user = user;
        return next();
    } catch (error) {
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json(createUnsuccessfulResponse(-1));
    }
}
