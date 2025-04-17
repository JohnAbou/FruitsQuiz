import 'package:flutter/material.dart';
import 'package:android_app/generated/l10n.dart';

String getLocalizedError(String serverKey, BuildContext context) {
  final translations = {
    'AccountValidation.MissingFields':
        S.of(context).AccountValidation_missingFields,
    'AccountValidation.IncorrectCredentials':
        S.of(context).AccountValidation_incorrectCredentials,
    'AccountValidation.AlreadyLoggedIn':
        S.of(context).AccountValidation_alreadyLoggedIn,
    'AccountValidation.EmailTaken': S.of(context).AccountValidation_emailTaken,
    'AccountValidation.UsernameTaken':
        S.of(context).AccountValidation_usernameTaken,
    'AccountValidation.RequiredUsername':
        S.of(context).AccountValidation_usernameRequired,
    'AccountValidation.NoSpecialCharactersUser':
        S.of(context).AccountValidation_usernameInvalid,
    'AccountValidation.InvalidUsername':
        S.of(context).AccountValidation_usernameSystem,
    'AccountValidation.UsernameCharacterLimit':
        S.of(context).AccountValidation_usernameLength,
    'AccountValidation.RequiredPassword':
        S.of(context).AccountValidation_passwordRequired,
    'AccountValidation.PasswordNbCharacter':
        S.of(context).AccountValidation_passwordLength,
    'AccountValidation.NoSpecialCharactersPassword':
        S.of(context).AccountValidation_passwordInvalid,
    'AccountValidation.MathcingPassword':
        S.of(context).AccountValidation_passwordMismatch,
    'AccountValidation.RequiredEmail':
        S.of(context).AccountValidation_emailRequired,
    'AccountValidation.EmailFormat':
        S.of(context).AccountValidation_emailInvalid,
    'AccountValidation.RequiredAvatar':
        S.of(context).AccountValidation_avatarRequired,
    'AccountValidation.RequiredTerms':
        S.of(context).AccountValidation_termsRequired,
    'AccountValidation.UpdateError':
        S.of(context).AccountValidation_updateError,
    'AccountValidation.UnknownError':
        S.of(context).AccountValidation_unknownError,
  };

  return translations[serverKey] ?? serverKey;
}
