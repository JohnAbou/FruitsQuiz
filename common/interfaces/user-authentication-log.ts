export interface AuthenticationLog {
    userId: string;
    sessionId: string;
    loginTime: Date;
    logoutTime?: Date;
    deviceType?: string; 
}
