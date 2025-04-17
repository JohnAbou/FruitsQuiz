import { TranslateService } from '@ngx-translate/core'; // Import TranslateService

/**
 * Checks if the username is valid.
 * Returns an error message if it's not valid, otherwise returns an empty string.
 */
export function validateUsername(username: string, translate: TranslateService): string {
    if (!username || !username.trim()) return translate.instant('AccountValidation.RequiredUsername');

    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(username))
        return translate.instant('AccountValidation.NoSpecialCharactersUser');

    if (username.toLowerCase() === 'system')
        return translate.instant('AccountValidation.InvalidUsername');

    if (username.length < 4 || username.length > 12)
        return translate.instant('AccountValidation.UsernameCharacterLimit');

    return "";
}

/**
 * Checks if the password is valid.
 * Returns an error message if it's not valid, otherwise returns an empty string.
 */
export function validatePassword(password: string, translate: TranslateService): string {
    if (!password || !password.trim()) return translate.instant('AccountValidation.RequiredPassword');

    if (password.length < 5) return translate.instant('AccountValidation.PasswordNbCharacter');

    const passwordRegex = /^[A-Za-z\d!@#$%^&*(),.?":{}|<>]+$/;
    if (!passwordRegex.test(password))
        return translate.instant('AccountValidation.NoSpecialCharactersPassword');

    return "";
}

/**
 * Checks if the email is valid.
 * Returns an error message if it's not valid, otherwise returns an empty string.
 */
export function validateEmail(email: string, translate: TranslateService): string {
    if (!email || !email.trim()) return translate.instant('AccountValidation.RequiredEmail');

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) return translate.instant('AccountValidation.EmailFormat');

    return "";
}

export function validateConfirmPassword(confirmPassword: string, password: string, translate: TranslateService): string {
    if (password !== confirmPassword) {
        return translate.instant('AccountValidation.MathcingPassword');
    }
    return "";
}

export function validateAvatar(avatar: string | null, translate: TranslateService): string {
    if (!avatar || avatar.trim() === '') {
        return translate.instant('AccountValidation.RequiredAvatar');
    }
    return "";
}
