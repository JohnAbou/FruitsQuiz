import 'package:android_app/generated/l10n.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_results_service.dart';

class ResultWinnerWidget extends ConsumerWidget {
  const ResultWinnerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColors = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<CustomColors>();
    final gameResult = ref.watch(gameResultProvider.select((state) => state.gameResult));

    final winnerName = gameResult.winner?.name ?? '';
    final wasTie = gameResult.wasTie;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 16.0, right: 16.0),
      child: Center(
        child: IntrinsicWidth(
          child: Card(
            elevation: 8,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: customColors?.accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      
                      Flexible(
                        child: Text(
                          '${S.of(context).result_winner_winner} $winnerName',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: mainColors.primary,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  if (wasTie) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: customColors?.textColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.loose,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF555555),
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${S.of(context).result_winner_tie_breaker} ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: mainColors.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '$winnerName ${S.of(context).result_winner_answered_faster}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  if (!wasTie) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            mainColors.primary,
                            mainColors.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: mainColors.secondary.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Champion',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
