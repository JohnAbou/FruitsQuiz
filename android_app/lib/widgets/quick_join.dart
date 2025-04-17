import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/games/game_joining_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/widgets/user_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickJoin extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  QuickJoin({super.key});

  joinGame(GameJoiningService service, BuildContext context, WidgetRef ref) {
    int? gameId = int.tryParse(_controller.text);

    if (gameId == null || gameId < 1000 || gameId > 9999) {
      return ref
          .read(notificationServiceProvider)
          .showBottomLeftNotification(S.current.game_joining_invalid_game_id);
    }

    service.joinGame(gameId, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: S.of(context).quick_join_label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () =>
              joinGame(ref.read(gameJoiningServiceProvider), context, ref),
          style: ElevatedButton.styleFrom(fixedSize: const Size(150, 45)),
          child: Text(S.of(context).quick_join_button),
        ),
        const SizedBox(width: 16), 
        const BalanceContainer(),
      ],
    );
  }
}