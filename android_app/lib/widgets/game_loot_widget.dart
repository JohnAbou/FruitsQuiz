import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/widgets/user_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_loot_service.dart';
import 'package:android_app/services/games/game_challenge_service.dart';
import 'package:android_app/generated/l10n.dart';

class GameLootWidget extends ConsumerWidget {
  final bool showCoinsPaid;

  const GameLootWidget({super.key, this.showCoinsPaid = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameLootState = ref.watch(gameLootProvider);
    final gameChallengeState = ref.watch(gameChallengeStateProvider);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      margin: const EdgeInsets.all(16.0),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                  child: _buildLootBox(
                    title: S.of(context).game_loot_coins,
                    boxColor: customColors.boxColor,
                    textColor: customColors.sidebarText,
                    showBalance: true,
                    items: [
                      _lootItem(
                        label: '${S.of(context).game_loot_coins_gained}: ',
                        value: gameLootState.coinLoot.coinGained,
                        customColors: customColors,
                      ),
                      _lootItem(
                        label: '${S.of(context).game_loot_challenge_coins_gained}: ',
                        value: gameChallengeState.success == true ? gameChallengeState.price : 0,
                        customColors: customColors,
                      ),
                      if (showCoinsPaid)
                        _lootItem(
                          label: '${S.of(context).game_loot_coins_paid}: ',
                          value: gameLootState.coinLoot.coinPayed,
                          customColors: customColors,
                        ),
                    ],
                  ),
                ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLootBox(
                      title: S.of(context).game_loot_experience,
                      boxColor: customColors.boxColor,
                      textColor: customColors.sidebarText,
                      items: [
                        _lootItem(
                          label: '${S.of(context).game_loot_xp_label}: ',
                          value: gameLootState.experienceLoot.expEnd,
                          customColors: customColors,
                        ),
                        _lootItem(
                          label: '${S.of(context).game_loot_xp_gained}: ',
                          value: gameLootState.experienceLoot.expGained,
                          customColors: customColors,
                        ),
                        if (gameLootState.experienceLoot.leveledUp) 
                          _lootItem(
                            label: S.of(context).game_loot_level_up,
                            value: null,
                            customColors: customColors,
                          ),
                        _buildProgressBar(gameLootState.experienceLoot, customColors),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLootBox({
  required String title, 
  required List<Widget> items,
  required Color boxColor,
  required Color textColor,
  bool showBalance = false,
}) {
  return Container(
    constraints: const BoxConstraints(
      minWidth: 250,
      maxWidth: 400,
    ),
    decoration: BoxDecoration(
      color: boxColor,
      border: Border.all(color: textColor.withOpacity(0.7), width: 2),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, 
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (showBalance) const BalanceContainer(),
          ],
        ),
        const SizedBox(height: 8),
        ...items,
      ],
    ),
  );
}

  Widget _lootItem({required String label, required int? value, required CustomColors customColors}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: customColors.sidebarText)),
          Text(value?.toString() ?? '', style: TextStyle(color: customColors.sidebarText)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ExperienceLoot experienceLoot, CustomColors customColors) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      clipBehavior: Clip.hardEdge,
      child: LinearProgressIndicator(
        value: experienceLoot.expEnd / (experienceLoot.expToNextLevel > 0 ? experienceLoot.expToNextLevel : 1),
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(customColors.sidebarText),
        minHeight: 6,
      ),
    );
  }
}