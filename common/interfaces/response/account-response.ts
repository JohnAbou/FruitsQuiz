export interface UserPreferences {
    theme: string;
    background: string;
    language: string;
}

export interface AccountResponse {
    usernameError?: string,
    emailError?: string,
    passwordError?: string,
    sessionId?: string,
    preferences?: UserPreferences,
}