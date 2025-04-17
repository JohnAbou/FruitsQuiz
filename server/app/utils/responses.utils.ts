import { Response } from '@common/interfaces/response/response';

export const createUnsuccessfulResponse = (errorCode: number): Response => {
    return {
        success: false,
        code: errorCode,
    };
};

export const createSuccessfulResponse = () => {
    return {
        success: true,
    };
};
