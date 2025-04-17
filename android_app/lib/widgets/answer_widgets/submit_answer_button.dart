import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/games/game_player_service.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/theme/custom_colors.dart';

class SubmitButton extends ConsumerWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSubmit = ref.watch(
        gamePlayerStateProvider.select((state) => state.canSubmitAnswer()));

    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>();
    final buttonBoxColor = customColors?.buttonBox ?? theme.colorScheme.primary;
    final buttonTextColor = customColors?.buttonText ?? Colors.white;
    final accentColor = customColors?.accentColor ?? theme.colorScheme.secondary;

    // Calculate screen width in vw units (like CSS)
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.22; // 22vw like web
    final fontSize = screenWidth * 0.02; // 2vw like web
    final borderRadius = screenWidth * 0.02; // 2vw like web

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: MouseRegion(
        cursor: canSubmit ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: canSubmit 
              ? (Matrix4.identity()..scale(1.0))
              : (Matrix4.identity()..scale(0.95)),
          child: ElevatedButton(
            onPressed: canSubmit
                ? () {
                    ref.read(gamePlayerServiceProvider).submitAnswers();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit ? buttonBoxColor : Colors.grey,
              foregroundColor: buttonTextColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              fixedSize: Size(buttonWidth, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(
                  color: canSubmit ? accentColor : Colors.grey,
                  width: 3,
                ),
              ),
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            child: Text(
              S.of(context).submit,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: canSubmit ? buttonTextColor : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
