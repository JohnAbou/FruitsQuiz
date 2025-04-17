import 'package:android_app/pages/history_page.dart';
import 'package:android_app/pages/leaderboard_page.dart';
import 'package:android_app/pages/public_profile_page.dart';
import 'package:android_app/pages/users_page.dart';
import 'package:android_app/providers/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_shell.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/game_pages/game_joining_page.dart';
import '../pages/game_pages/game_view_page.dart';
import '../pages/game_pages/game_creation_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/personal_profile_page.dart';
import '../pages/shop_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    navigatorKey: navigatorKey,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: '/game-joining',
            builder: (context, state) => const GameJoiningPage(),
          ),
          GoRoute(
            path: '/game-view',
            builder: (context, state) => const GameViewPage(),
          ),
          GoRoute(
            path: '/game-creation',
            builder: (context, state) => const GameCreationPage(),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersPage(),
          ),
          GoRoute(
            path: '/personal-profile',
            builder: (context, state) {
              final tab = state.uri.queryParameters['tab'] ?? 'information';
              return PersonalProfilePage(tab: tab);
            },
          ),
          GoRoute(
            path: '/public-profile',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'] ?? '';
              return PublicProfilePage(id: id);
            },
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => const ShopPage(),
          ),
          GoRoute(
            path: '/leaderboard',
            builder: (context, state) => const LeaderboardPage(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryPage(),
          )
        ],
      ),
    ],
    redirect: (context, state) {
      return null;
    },
    refreshListenable: RouterNotifier(ref),
  );
});
