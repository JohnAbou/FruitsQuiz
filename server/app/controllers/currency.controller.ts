import { Request, Response } from 'express';
import { Service } from 'typedi';
import { UserDataManager } from '@app/services/data/user-data-manager.service';
import { StatusCodes } from 'http-status-codes';
import { BaseController } from './base-controller';

@Service()
export class CurrencyController extends BaseController {

	constructor(private userDataManager: UserDataManager) {
		super();
	}

	protected configureRouter(): void {
		this.router.post('/:id', this.addCurrency.bind(this));
		this.router.get('/:id', this.getCurrency.bind(this));
		this.router.post('/:id/remove', this.removeCurrency.bind(this));
	}

	private async getCurrency(req: Request, res: Response) {
		this.attemptOperation(res, async () => {
			const { id } = req.params;
			let user = await this.userDataManager.getElementById(id) as any;
			
			user ??= { id, currency: 0 };
			return res.json({ currency: user.currency });
		});
	}

	private async addCurrency(req: Request, res: Response) {
		this.attemptOperation(res, async () => {
			const { id } = req.params;
			const { amount } = req.body;

			if (!id) {
				return res.status(StatusCodes.BAD_REQUEST).json({ message: 'User ID is required in URL' });
			}
			if (amount === undefined || amount <= 0) {
				return res.status(StatusCodes.BAD_REQUEST).json({ message: 'Valid amount is required to add' });
			}

			let currency = await this.userDataManager.addUserCurrency(id, amount);

			return res.json({ message: 'Currency updated', currency });
		});
	}

	private async removeCurrency(req: Request, res: Response) {
		this.attemptOperation(res, async () => {
			const { id } = req.params;
			const { amount } = req.body;

			if (!id) {
				return res.status(StatusCodes.BAD_REQUEST).json({ message: 'User ID is required in URL' });
			}
			if (amount === undefined || amount <= 0) {
				return res.status(StatusCodes.BAD_REQUEST).json({ message: 'Valid amount is required to remove' });
			}

			let user = await this.userDataManager.getElementById(id) as any;

			if (!user || user.currency === undefined) {
				return res.json({ success: false, message: 'Insufficient funds' });
			}

			if (user.currency < amount) {
				return res.json({ success: false, message: 'Insufficient funds' });
			}

			const currency = await this.userDataManager.removeUserCurrency(id, amount);

			return res.json({ success: true, currency });
		});
	}
}
