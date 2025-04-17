import 'package:android_app/generated/l10n.dart';
import 'package:flutter/material.dart';

enum BotDifficulty {
  beginner,
  intermediate,
  expert,
}

extension BotDifficultyExtension on BotDifficulty {
  String get displayName {
    switch (this) {
      case BotDifficulty.beginner:
        return 'Beginner';
      case BotDifficulty.intermediate:
        return 'Intermediate';
      case BotDifficulty.expert:
        return 'Expert';
    }
  }

  static BotDifficulty fromString(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return BotDifficulty.beginner;
      case 'intermediate':
        return BotDifficulty.intermediate;
      case 'expert':
        return BotDifficulty.expert;
      default:
        throw ArgumentError('Invalid BotDifficulty string: $difficulty');
    }
  }

  static String translateDifficulty(
      BuildContext context, BotDifficulty difficulty) {
    switch (difficulty) {
      case BotDifficulty.beginner:
        return S.of(context).bot_difficulty_beginner;
      case BotDifficulty.intermediate:
        return S.of(context).bot_difficulty_intermediate;
      case BotDifficulty.expert:
        return S.of(context).bot_difficulty_expert;
    }
  }
}
