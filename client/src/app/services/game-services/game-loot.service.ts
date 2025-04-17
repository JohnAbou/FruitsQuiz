import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { GameListenerService } from './base-classes/game-listener.service';
import { SocketFactoryService } from '../socket-service/socket-factory.service';
import { DialogModalService } from '../dialog-modal.service';
import { TranslateService } from '@ngx-translate/core';

export interface CoinLoot {
    coinGained: number;
    coinPayed: number;
}

export interface ExperienceLoot {
    leveledUp: boolean;
    expGained: number;
    expEnd: number;
    expToNextLevel: number;
}

@Injectable({
    providedIn: 'root',
})
export class GameLootService extends GameListenerService {
    private coinLootSubject: BehaviorSubject<CoinLoot>;
    private experienceLootSubject: BehaviorSubject<ExperienceLoot>;

    get coinLoot() {
        return this.coinLootSubject.asObservable();
    }

    get experienceLoot() {
        return this.experienceLootSubject.asObservable();
    }

    constructor(
        socketFactory: SocketFactoryService,
        private dialog: DialogModalService,
        private translate: TranslateService,
    ) {
        super(socketFactory);
    }

    protected setUpSocket() {
        this.socketService.on('gameLootCoins', (loot: CoinLoot) => this.coinLootSubject.next(loot));
        this.socketService.on('gameLootExp', (loot: ExperienceLoot) => this.experienceLootSubject.next(loot));
        this.socketService.on('wonTheGamePot', (price: number) => this.wonTheGamePot(price));
    }

    protected initializeState() {
        this.coinLootSubject ??= new BehaviorSubject<CoinLoot>({ coinGained: 0, coinPayed: 0 });
        this.coinLootSubject.next({ coinGained: 0, coinPayed: 0 });

        this.experienceLootSubject ??= new BehaviorSubject<ExperienceLoot>({ leveledUp: false, expGained: 0, expEnd: 0, expToNextLevel: 0 });  
        this.experienceLootSubject.next({ leveledUp: false, expGained: 0, expEnd: 0, expToNextLevel: 0 });
    }

    private wonTheGamePot(price: number) {
        this.dialog.openSnackBar(
            this.translate.instant('GameLoot.WonTheGamePot', { price }),
        );
    }
}
