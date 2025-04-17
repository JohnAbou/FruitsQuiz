import { Service } from 'typedi';
import { DataManagerService } from './data-manager.service';
import { DataBaseAcces } from './database-acces.service';
import { CHAT_COLLECTION } from '@app/consts/database.consts';
import { Chat } from '@common/interfaces/chat/chat';

@Service()
export class DatabaseCleanerService extends DataManagerService<any> {
    constructor(dbAcces: DataBaseAcces) {
        super(dbAcces);
        dbAcces.dbConnectionEmitter.on('dbConnected', async () => {
            console.log('Database connected, cleaning up...');
            await this.deleteAllChats();
        });
    }

    private async deleteAllChats() {
        this.setCollection(CHAT_COLLECTION);
        await this.deleteAllElements();

        const globalChat: Chat = {
            id: '1',
            name: 'Global',
            creatorUsername: 'System',
            messages: [],
            isFriendsOnly: false,
        };
        await this.addElement(globalChat);
    }
}
