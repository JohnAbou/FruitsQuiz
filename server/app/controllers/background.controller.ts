import { Response } from 'express';
import { Service } from 'typedi';
import { BaseController } from './base-controller';
import { getUserIdMiddleware, RequestWithUserId } from '@app/middlewares/userId-required-middleware';
import { UserDataManager } from '@app/services/data/user-data-manager.service';

@Service()
export class BackgroundController extends BaseController {

  constructor(private dataManager: UserDataManager) {
    super();
  }

  protected configureRouter(): void {
    this.router.put('/', getUserIdMiddleware, this.updateBackground.bind(this));
    this.router.get('/', getUserIdMiddleware, this.getBackground.bind(this));
  }

  private async updateBackground(req: RequestWithUserId, res: Response) {
    this.attemptOperation(res, async () => {
    const result = await this.dataManager.updateUserBackground(req.userId, req.body.background);
     res.json({success: result});
      
    });
  }

  private async getBackground(req: RequestWithUserId, res: Response) {
    this.attemptOperation(res, async () => {
      const user = await this.dataManager.getElementById(req.userId) as any;
      const background = user?.background ?? 'none';
      res.json({ background });
    });
  }
}
