import 'package:android_app/providers/theme_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/chat_service.dart';
import 'package:android_app/services/currency_service.dart';
import 'package:android_app/services/friends_service.dart';
import 'package:android_app/services/games/game_service_initializer.dart';
import 'package:android_app/services/language_settings_service.dart';
import 'package:android_app/services/shop_service.dart';
import 'package:android_app/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/app_routes.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AppLifecycleHandler extends WidgetsBindingObserver {
  final Function(AppLifecycleState) onChanged;

  AppLifecycleHandler({required this.onChanged});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onChanged(state);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  await dotenv.load(fileName: _getEnvFile());

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const ProviderScope(child: MyApp()));
}

String _getEnvFile() {
  return const bool.fromEnvironment('dart.vm.product')
      ? ".env.production"
      : ".env";
}

final localeProvider = StateProvider<Locale>((ref) => const Locale('fr'));

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLifecycleHandler _lifecycleHandler;

  @override
  void initState() {
    super.initState();
    _lifecycleHandler = AppLifecycleHandler(onChanged: (state) {
      ref.read(chatServiceProvider).updateAppState(state);
      
      if (state == AppLifecycleState.detached) {
        ref.read(authServiceProvider).logout();
      }
    });
    WidgetsBinding.instance.addObserver(_lifecycleHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(goRouterProvider);
    final themeService = ref.watch(themeServiceProvider);

    // Initialize additional services.
    ref.read(friendsServiceProvider);
    ref.read(chatServiceProvider);
    ref.read(gameServiceInitializerProvider);
    ref.read(languageSettingServiceProvider);
    ref.read(themeServiceProvider.notifier);
    ref.read(shopServiceProvider);
    ref.read(currencyProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: getThemeData(themeService.currentTheme, themeService.currentBackground),
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
    );
  }
}
