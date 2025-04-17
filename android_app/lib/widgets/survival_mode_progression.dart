import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/games/game_survival_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurvivalModeProgression extends ConsumerWidget {
  const SurvivalModeProgression({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionCount = ref.watch(
        gameInfoStateProvider.select((state) => state.quiz.questions.length));
    final questionSurvived = ref
        .watch(gameSurvivalProvider.select((state) => state.questionSurvived));
    
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).survival_mode_progression_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: questionCount > 0
                          ? questionSurvived / questionCount
                          : 0,
                      strokeWidth: 8,
                      color: accentColor,
                    ),
                  ),
                  Text(
                    '$questionSurvived / $questionCount',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
