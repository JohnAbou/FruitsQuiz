import { Request, Response, NextFunction } from 'express';
import { Container } from 'typedi';
import { UsersSessionsService } from '@app/services/users/user-sessions.service';
import { StatusCodes } from 'http-status-codes';
import { createUnsuccessfulResponse } from '@app/utils/responses.utils';

export interface RequestWithUserId extends Request {
    userId?: string;
}

export async function getUserIdMiddleware(req: RequestWithUserId, res: Response, next: NextFunction) {
    try {
        const sessionId = req.headers['x-session-id'] as string;
        if (!sessionId) {
            return res.status(StatusCodes.BAD_REQUEST).json(createUnsuccessfulResponse(-1));
        }

        const userSessionsService = Container.get(UsersSessionsService);
        const userId = userSessionsService.getUserIdFromSession(sessionId);
        if (!userId) {
            return res.status(StatusCodes.NOT_FOUND).json(createUnsuccessfulResponse(-1));
        }

        req.userId = userId;
        return next();
    } catch (error) {
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json(createUnsuccessfulResponse(-1));
    }
}
