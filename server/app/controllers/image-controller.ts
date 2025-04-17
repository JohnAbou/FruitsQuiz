import { Request, Response } from 'express';
import { Service } from 'typedi';
import * as multer from 'multer';
import { ImageService } from '@app/services/image/image.service';
import { StatusCodes } from 'http-status-codes';
import { AvatarIds } from '@app/consts/avatar.consts';
import { BaseController } from './base-controller';
import { IMAGE } from '@app/consts/image.consts';

const upload = multer({ storage: multer.memoryStorage() });

@Service()
export class ImageController extends BaseController {
    constructor(private imageService: ImageService) {
        super();
    }

    protected configureRouter(): void {
        this.router.post('/question/upload', upload.single('image'), this.uploadQuestionImage.bind(this));
        this.router.get('/question/:id', this.getQuestionImage.bind(this));

        this.router.post('/avatar/upload', upload.single('image'), this.uploadAvatarImage.bind(this));
        this.router.get('/avatar/:id', this.getAvatarImage.bind(this));

        this.router.delete('/:id', this.deleteImage.bind(this));
    }
    
    private async uploadQuestionImage(req: Request, res: Response): Promise<void> {
        try {
            if (!req.file) {
                res.status(StatusCodes.BAD_REQUEST).json({ error: IMAGE.ERROR.NO_FILE_PROVIDED });
                return;
            }
            const imageId = await this.imageService.processQuestionImage(req.file.buffer);
            res.json({ imageId: `${imageId}` });
        } catch (error) {
            this.handleError(res, error.message);
        }
    }

    private async getQuestionImage(req: Request, res: Response): Promise<void> {
        try {
            const imageStream = this.imageService.getImageStream(req.params.id);
            if (!imageStream) {
                res.status(StatusCodes.NOT_FOUND).json({ error: IMAGE.ERROR.NOT_FOUND });
                return;
            }
            imageStream.pipe(res);
        } catch (error) {
            this.handleError(res, error.message);
        }
    }

    private async uploadAvatarImage(req: Request, res: Response): Promise<void> {
        try {
            if (!req.file) {
                res.status(StatusCodes.BAD_REQUEST).json({ error: IMAGE.ERROR.NO_FILE_PROVIDED });
                return;
            }
            const imageId = await this.imageService.processAvatarImage(req.file.buffer);
            res.json({ imageId: `${imageId}` });
        } catch (error) {
            this.handleError(res, error.message);
        }
    }

    private async getAvatarImage(req: Request, res: Response): Promise<void> {
        try {
            const id = AvatarIds.has(req.params.id)
                ? AvatarIds.get(req.params.id)
                : req.params.id;

            const imageStream = this.imageService.getImageStream(id);
            imageStream.pipe(res);
        } catch (error) {
            this.handleError(res, error.message);
        }
    }

    private async deleteImage(req: Request, res: Response): Promise<void> {
        try {
            await this.imageService.deleteImage(req.params.id);
            res.status(StatusCodes.OK).json({ message: IMAGE.MESSAGE.DELETED_SUCCESSFULLY });
        } catch (error) {
            this.handleError(res, error.message);
        }
    }
}
