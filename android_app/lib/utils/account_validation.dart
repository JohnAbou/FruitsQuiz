import 'package:android_app/generated/l10n.dart';
import 'package:flutter/material.dart';

String? validateUsername(BuildContext context, String username) {
  if (username.trim().isEmpty) return S.of(context).error_username_required;

  final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  if (!usernameRegex.hasMatch(username)) {
    return S.of(context).error_username_invalid;
  }

  if (username.toLowerCase() == 'system') {
    return S.of(context).error_username_system;
  }

  if (username.length < 4 || username.length > 12) {
    return S.of(context).error_username_length;
  }

  return null;
}

String? validatePassword(BuildContext context, String password) {
  if (password.trim().isEmpty) return S.of(context).error_password_required;

  if (password.length < 5) return S.of(context).error_password_length;

  final passwordRegex = RegExp(r'^[A-Za-z\d!@#$%^&*(),.?":{}|<>]+$');
  if (!passwordRegex.hasMatch(password)) {
    return S.of(context).error_password_invalid;
  }

  return null;
}

String? validateEmail(BuildContext context, String email) {
  if (email.trim().isEmpty) return S.of(context).error_email_required;

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(email)) {
    return S.of(context).error_email_invalid;
  }

  return null;
}
