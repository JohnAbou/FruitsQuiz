import { Request, Response, NextFunction } from 'express';

export function imageValidationMiddleware(req: Request, res: Response, next: NextFunction): void {
    if (!req.file) {
        res.status(400).json({ error: 'No file provided' });
        return;
    }

    const allowedMimeTypes = ['image/jpeg', 'image/png'];
    if (!allowedMimeTypes.includes(req.file.mimetype)) {
        res.status(415).json({ error: 'Unsupported file type. Only JPEG and PNG are allowed.' });
        return;
    }

    const maxSize = 5 * 1024 * 1024; 
    if (req.file.size > maxSize) {
        res.status(413).json({ error: 'File is too large. Maximum allowed size is 5MB.' });
        return;
    }

    next();
}