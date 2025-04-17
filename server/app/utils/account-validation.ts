import * as i18next from 'i18next'; 
/**
 * Checks if the username is valid.
 */
export function validateUsername(username: string, t: i18next.TFunction): string {
    if (!username || !username.trim()) 
        return 'AccountValidation.RequiredUsername';

    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(username))
        return 'AccountValidation.NoSpecialCharactersUser';

    if (username.toLowerCase() === 'system')
        return 'AccountValidation.InvalidUsername';

    if (username.length < 4 || username.length > 12)
        return 'AccountValidation.UsernameCharacterLimit';

    return "";
}

/**
 * Checks if the password is valid.
 */
export function validatePassword(password: string,  t: i18next.TFunction): string {
    if (!password || !password.trim()) 
        return 'AccountValidation.RequiredPassword';

    if (password.length < 5) 
        return 'AccountValidation.PasswordNbCharacter';

    const passwordRegex = /^[A-Za-z\d!@#$%^&*(),.?":{}|<>]+$/;
    if (!passwordRegex.test(password)) 
        return 'AccountValidation.NoSpecialCharactersPassword';

    return "";
}

/**
 * Checks if the email is valid.
 */
export function validateEmail(email: string, t: i18next.TFunction): string {
    if (!email || !email.trim()) 
        return 'AccountValidation.RequiredEmail';

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) 
        return 'AccountValidation.EmailFormat';

    return "";
}

export function validateConfirmPassword(confirmPassword: string, password: string, t: i18next.TFunction): string {
    if (password !== confirmPassword) return t('accountValidation.passwordMismatch');
    return "";
}
