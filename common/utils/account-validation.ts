/**
 * Checks if the username is valid.
 * Returns an error message if it's not valid, otherwise returns an empty string.
 */
export function validateUsername(username: string): string {
    if (!username || !username.trim()) return "Le nom d'utilisateur est requis";

    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(username))
        return "Le nom d'utilisateur ne peut pas contenir de caractères spéciaux";

    if (username.length < 4 || username.length > 20)
        return "Le nom d'utilisateur doit comporter entre 4 et 20 caractères";

    return "";
}

/**
 * Checks if the password is valid.
 * Returns an error message if it's not valid, otherwise returns an empty string.
 */
export function validatePassword(password: string): string {
    if (!password || !password.trim()) return "Le mot de passe est requis.";

    if (password.length < 5) return "Le mot de passe doit comporter au moins 5 caractères.";

    const passwordRegex = /^[A-Za-z\d!@#$%^&*(),.?":{}|<>]+$/;
    if (!passwordRegex.test(password))
        return "Le mot de passe ne peut contenir que des lettres, des chiffres et des caractères spéciaux.";

    return "";
}

/**
 * Checks if the email is valid.
 * Returns an error message if it's not valid, otherwise returns an empty string.
 */
export function validateEmail(email: string): string {
    if (!email || !email.trim()) return "L'email est requis.";

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) return "L'email doit respecter la forme exemple@domaine.com";

    return "";
}

export function validateConfirmPassword(confirmPassword: string, password: string): string {
    if (password !== confirmPassword) {
        return 'Les mots de passe ne correspondent pas.';
    }
    return ""
}