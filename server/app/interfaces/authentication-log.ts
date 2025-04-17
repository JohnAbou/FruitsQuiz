export interface AuthenticationLog {
    id: string;
    userId: string;
    sessionId: string;
    loginTime: Date;
    logoutTime?: Date;
    deviceType?: string; 
}
