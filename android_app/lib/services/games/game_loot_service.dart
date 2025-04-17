import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameLootState {
  final CoinLoot coinLoot;
  final ExperienceLoot experienceLoot;

  GameLootState({
    required this.coinLoot,
    required this.experienceLoot,
  });

  GameLootState copyWith({
    CoinLoot? coinLoot,
    ExperienceLoot? experienceLoot,
  }) {
    return GameLootState(
      coinLoot: coinLoot ?? this.coinLoot,
      experienceLoot: experienceLoot ?? this.experienceLoot,
    );
  }
}

final defaultGameLootState = GameLootState(
  coinLoot: CoinLoot(coinGained: 0, coinPayed: 0),
  experienceLoot: ExperienceLoot(
      leveledUp: false, expGained: 0, expEnd: 0, expToNextLevel: 0),
);

class GameLootService extends BaseGameService<GameLootState> {
  final NotificationService notificationService;

  GameLootService({required socketService, required this.notificationService})
      : super(socketService, defaultGameLootState);

  @override
  void initializeState() {
    state = defaultGameLootState;
  }

  @override
  void setUpSocketListener() {
    addSocketListener('gameLootCoins', (loot) {
      _updateCoinLoot(CoinLoot.fromJson(loot));
    });

    addSocketListener('gameLootExp', (loot) {
      _updateExperienceLoot(ExperienceLoot.fromJson(loot));
    });

    addSocketListener('wonTheGamePot', (pot) {
      _wonTheGamePot(pot);
    });
  }

  _updateCoinLoot(CoinLoot coinLoot) {
    state = state.copyWith(coinLoot: coinLoot);
  }

  _updateExperienceLoot(ExperienceLoot experienceLoot) {
    state = state.copyWith(experienceLoot: experienceLoot);
  }

  _wonTheGamePot(int pot) {
    notificationService.showBottomLeftNotification(S.current.game_loot_won_game_pot(pot));
  }
}

// Provider
final gameLootProvider =
    StateNotifierProvider<GameLootService, GameLootState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  return GameLootService(
      socketService: socketService, notificationService: notificationService);
});

class CoinLoot {
  final int coinGained;
  final int coinPayed;

  CoinLoot({required this.coinGained, required this.coinPayed});

  factory CoinLoot.fromJson(Map<String, dynamic> json) {
    return CoinLoot(
        coinGained: json['coinGained'] ?? 0, coinPayed: json['coinPayed'] ?? 0);
  }
}

class ExperienceLoot {
  final bool leveledUp;
  final int expGained;
  final int expEnd;
  final int expToNextLevel;

  ExperienceLoot({
    required this.leveledUp,
    required this.expGained,
    required this.expEnd,
    required this.expToNextLevel,
  });

  factory ExperienceLoot.fromJson(Map<String, dynamic> json) {
    return ExperienceLoot(
      leveledUp: json['leveledUp'] ?? false,
      expGained: (json['expGained'] ?? 0).toDouble().toInt(),
      expEnd: (json['expEnd'] ?? 0).toDouble().toInt(),
      expToNextLevel: (json['expToNextLevel'] ?? 0).toDouble().toInt(),
    );
  }
}
