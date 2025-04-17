import 'package:flutter/material.dart';
import 'package:android_app/widgets/timer.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/widgets/themed_scaffold.dart'; 

class GameIntermissionPage extends StatelessWidget {
  const GameIntermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ThemedScaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).prepare_yourself,
                  style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                const Timer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
