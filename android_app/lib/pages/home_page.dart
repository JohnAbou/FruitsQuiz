import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/api_service.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/home_page_buttons.dart';
import 'package:android_app/widgets/leaderboard_carousel.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<dynamic>? quizData;
  bool isLoading = false;
  String? errorMessage;
  bool isChatOpen = false;
  AuthState get authState => ref.watch(authStateProvider);

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    try {
      final data = await ref.read(fetchDataProvider.future);
      if (mounted) {
        setState(() {
          quizData = data;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String formatDateTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final logoAsset = customColors?.logoUrl ?? 'assets/images/logo.png';

    var content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                logoAsset,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const HomePageButtons(),
              const SizedBox(height: 20),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      S.of(context).home_page_team,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).home_page_team_members,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LeaderboardCarouselWidget(),
            ],
          ),
        ],
      ),
    );

    return buildDefaultPage(content);
  }
}
