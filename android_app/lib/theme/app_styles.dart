import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle fruitzTitle(BuildContext context) {
    return TextStyle(
      fontSize: 44,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle fruitzSubtitle(BuildContext context) {
    return TextStyle(
      fontSize: 32,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
  }
}
