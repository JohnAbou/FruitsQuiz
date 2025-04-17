import { Response } from 'express';
import { Service } from 'typedi';
import { BaseController } from './base-controller';
import { getUserIdMiddleware, RequestWithUserId } from '@app/middlewares/userId-required-middleware';
import { UserDataManager } from '@app/services/data/user-data-manager.service';

@Service()
export class ThemesController extends BaseController {

  constructor(private userDataManager: UserDataManager) {
    super();
  }

  protected configureRouter(): void {
    this.router.put('/', getUserIdMiddleware, this.updateTheme.bind(this));
    this.router.get('/', getUserIdMiddleware, this.getTheme.bind(this));
  }

  private async updateTheme(req: RequestWithUserId, res: Response) {
    this.attemptOperation(res, async () => {
    const result = await this.userDataManager.updateUserTheme(req.userId, req.body.theme);
    res.json({success: result});
    });
  }

  private async getTheme(req: RequestWithUserId, res: Response) {
    this.attemptOperation(res, async () => {
      let user = await this.userDataManager.getElementById(req.userId) as any;
      let theme = user.theme ?? 'lemon-theme';
      res.json({ theme });
    });
  }
}
