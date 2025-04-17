import { Injectable } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
    providedIn: 'root',
})
export class MessageTranslationService {
    private messages = new Map([
        [100, 'MessageTranslation.NotConnected'],

        [10000, 'GameJoining.NoGameFound'],
        [10001, 'GameJoining.InvalidGameId'],
        [10002, 'GameJoining.GameAlreadyStarted'],
        [10005, 'GameJoining.LobbyLocked'],
        [10010, 'GameJoining.BannedUser'],
        [10015, 'GameJoining.FriendsOnlyResponse'],
        [10016, 'GameJoining.NotEnoughCoins'],

        [20000,  'GameMessage.CorrectionWithBonus'],
        [20005, 'GameMessage.CorrectionWithoutBonus'],
        [20010, 'GameMessage.CorrectionWithPercentage'],

        [21000, 'KickedOutMessage.OrganizerLeft'],
        [21005, 'KickedOutMessage.NoPlayersLeft'],
        [21010, 'KickedOutMessage.Banned']
 
    ]);

    constructor(private readonly translateService: TranslateService) {}

    getTranslatedMessage(code: number) {
        if (code === -1) throw new Error("Didn't know this message was used");
        return this.translateService.instant(this.messages.get(code)!);
    }

    getTranslateMessageWithValues(code: number, values: object) {
        return this.translateService.instant(this.messages.get(code)!, values);
    }
}
