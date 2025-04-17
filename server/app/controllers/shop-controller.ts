import { Request, Response, Router } from 'express';
import { Service } from 'typedi';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { StatusCodes } from 'http-status-codes';

interface ShopItem {
  id: number;
  name: string;
  image: string;
  type: string;
  price: number;
  state: 0 | 1 | 2;
}

const DEFAULT_SHOP_ITEMS: ShopItem[] = [
  { id: 1, name: 'Strawberry Background', image: 'assets/shop/strawberrybackground.png', type: 'background', price: 50, state: 0 },
  { id: 2, name: 'Blueberry Background', image: 'assets/shop/blueberrybackground.png', type: 'background', price: 40, state: 0 },
  { id: 3, name: 'Lemon Background', image: 'assets/shop/lemonbackground.png', type: 'background', price: 30, state: 0 },
  { id: 4, name: 'Orange Background', image: 'assets/shop/orangesbackground.png', type: 'background', price: 30, state: 0 },
  { id: 5, name: 'Watermelon Background', image: 'assets/shop/watermelonbackground.png', type: 'background', price: 30, state: 0 },
  { id: 6, name: 'Strawberry Theme', image: 'assets/shop/strawberrylogo.png', type: 'theme', price: 60, state: 0 },
  { id: 7, name: 'Blueberry Theme', image: 'assets/shop/blueberrylogo1.png', type: 'theme', price: 70, state: 0 },
  { id: 8, name: 'Watermelon Theme', image: 'assets/shop/watermelonlogo.png', type: 'theme', price: 80, state: 0 },
  { id: 9, name: 'Premium Lemon Avatar', image: 'assets/avatars/premium_lemon_avatar.png', type: 'avatar', price: 300, state: 0 },
  { id: 10, name: 'Premium Orange Avatar', image: 'assets/avatars/premium_orange_avatar.png', type: 'avatar', price: 200, state: 0 },
  { id: 11, name: 'Golden Blueberry Avatar', image: 'assets/avatars/golden_blueberry_avatar.png', type: 'avatar', price: 20, state: 0 },
  { id: 12, name: 'Golden Lemon Avatar', image: 'assets/avatars/golden_lemon_avatar.png', type: 'avatar', price: 20, state: 0 },
  { id: 13, name: 'Golden Watermelon Avatar', image: 'assets/avatars/golden_watermelon_avatar.png', type: 'avatar', price: 20, state: 0 }
];

@Service()
export class ShopController {
  public router: Router;

  constructor(private dataManager: DataManagerService<any>) {
    this.router = Router();
    this.dataManager.setCollection('shop');
    this.initRoutes();
  }

  private initRoutes(): void {
    this.router.get('/:userId', this.getShop.bind(this));
    this.router.post('/:userId', this.updateShop.bind(this));
  }

  private async getShop(req: Request, res: Response) {
    try {
      const { userId } = req.params;
      
      const allShops = await this.dataManager.getElements();
      let shop = allShops.find(shop => shop.userId === userId);
      
      if (!shop) {
        shop = { userId, items: DEFAULT_SHOP_ITEMS };
        const added = await this.dataManager.addElement(shop);
        if (!added) {
          return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Failed to create shop for user' });
        }
      }
      
      return res.json(shop);
    } catch (error) {
      console.error('Error in getShop:', error);
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Server error', error: error.toString() });
    }
  }
  
  private async updateShop(req: Request, res: Response) {
    try {
      const { userId } = req.params;
      const { items } = req.body;
  
      if (!Array.isArray(items)) {
        return res.status(StatusCodes.BAD_REQUEST).json({ message: 'Invalid shop items format' });
      }
  
      const allShops = await this.dataManager.getElements();
      const existingShop = allShops.find(shop => shop.userId === userId);
  
      if (!existingShop) {
        return res.status(StatusCodes.NOT_FOUND).json({ message: 'Shop not found for user' });
      }
  
      const updated = await this.dataManager.updateElement(
        { userId }, 
        { items } 
      );
  
      if (!updated) {
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Failed to update shop' });
      }
      return res.json({message: "success"});
    } catch (error) {
      console.error('Error in updateShop:', error);
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: 'Server error', error: error.toString() });
    }
  }
}