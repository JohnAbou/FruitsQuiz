import { Service } from 'typedi';
import { randomUUID } from 'crypto';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { DataBaseAcces } from '@app/services/data/database-acces.service';
import { AUTHENTICATION_LOG_COLLECTION } from '@app/consts/database.consts';
import { AuthenticationLog } from '@app/interfaces/authentication-log';

@Service({ transient: true })
export class AuthenticationLogService extends DataManagerService<AuthenticationLog> {

    constructor(dbAcces: DataBaseAcces) {
        super(dbAcces);
        this.setCollection(AUTHENTICATION_LOG_COLLECTION);
    }

    async recordLogin(userId: string, sessionId: string, deviceType: string): Promise<string> {
        const entry: AuthenticationLog = {
            id: randomUUID(),
            userId,
            sessionId,
            loginTime: new Date(),
            deviceType,  
        };
    
        const success = await this.addElement(entry);
        return success ? entry.id : null;
    }
    

    async recordLogout(sessionId: string): Promise<void> {
        const entries = await this.getElementsByFilter({ sessionId });
        if (entries && entries.length > 0) {
            await this.updateElements(
                { sessionId },
                { logoutTime: new Date() }
            );
        }
    }

    async getAuthenticationLog(userId: string): Promise<AuthenticationLog[]> {
        return await this.getElementsByFilter({ userId : userId });
    }
}
