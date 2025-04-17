import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/currency_service.dart';
import 'package:android_app/services/games/game_player_service.dart';
import 'package:android_app/widgets/user_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBuyHintWidget extends ConsumerWidget {
  const GameBuyHintWidget({super.key});

  void buyHint(WidgetRef ref) {
    ref.read(gamePlayerServiceProvider).buyHint();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hintAvailable = ref.watch(
      gamePlayerStateProvider.select((state) => state.hintUsable),
    );
    final hintCost = ref.watch(
      gamePlayerStateProvider.select((state) => state.hintCost),
    );

    final currency = ref.watch(currencyProvider);

    final isEnabled = hintAvailable && currency > hintCost;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: isEnabled ? () => buyHint(ref) : null,
            icon: const Icon(Icons.lightbulb_outline, size: 20),
            label: Text(
              S.of(context).hint_widget_buy_hint(hintCost),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor:
                  isEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(0, 40), // compact height
            ),
          ),
          const SizedBox(height: 8),
          const BalanceContainer(),
        ],
      ),
    );
  }
}
