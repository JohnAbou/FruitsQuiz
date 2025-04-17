import { Request, Response, Router } from 'express';
import { Service } from 'typedi';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { StatusCodes } from 'http-status-codes';

@Service()
export class LanguageController {
  public router: Router;

  constructor(private dataManager: DataManagerService<any>) {
    this.router = Router();
    this.dataManager.setCollection('users');
    this.initRoutes();
  }

  private initRoutes(): void {
    this.router.post('/:id', this.updateLanguage.bind(this));
    this.router.get('/:id', this.getLanguage.bind(this));
  }
  private async updateLanguage(req: Request, res: Response) {
    try {
        const { id } = req.params;
        const { language } = req.body;
        if (!id) {
            return res.status(StatusCodes.BAD_REQUEST).json({ message: 'User ID is required in URL' });
        }
        if (!language) {
            return res.status(StatusCodes.BAD_REQUEST).json({ message: 'Language is required' });
        }
        let user = await this.dataManager.getElementById(id);

        if (!user) {
            user = { id, language };
            const added = await this.dataManager.addElement(user);
            if (!added) {
                return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Failed to add language record' });
            }
        } else {
            const updated = await this.dataManager.updateElement({ id }, { language });
            if (!updated) {
                return res.json({ message: 'Language updated', language });
            }
        }

        return res.json({ message: 'Language updated', language });
    } catch (error) {
        console.error('Error in updateLanguage:', error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Server error', error: error.toString() });
    }
}

  private async getLanguage(req: Request, res: Response) {
    try {
        const { id } = req.params;
        let user = await this.dataManager.getElementById(id);
        if (user && !user.language) {
            user.language = 'fr';

            const updated = await this.dataManager.replaceElement(user);
            if (!updated) {
                return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Failed to update language record' });
            }
        } 
        if (!user) {
            user = { id, language: 'fr' };
            const added = await this.dataManager.addElement(user);
            if (!added) {
                return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Failed to create language record' });
            }
        }
        return res.json({ language: user.language });
    } catch (error) {
        console.error('Error in getLanguage:', error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Server error', error: error.toString() });
    }
}

}
