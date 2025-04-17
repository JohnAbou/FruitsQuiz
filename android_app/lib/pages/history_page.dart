import 'package:android_app/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/game_log_service.dart';
import 'package:android_app/services/auth_log_service.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:intl/intl.dart';
import 'package:android_app/main.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = _tabController.index;
        });
      }
    });
    ref.read(gameLogServiceProvider.notifier).reloadGameLogs();
    ref.read(authLogServiceProvider.notifier).reloadAuthLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildDefaultPage(
      Column(
        children: [
          const SizedBox(height: 32),
          Text(S.of(context).log_history_title,
              style: AppTextStyles.fruitzSubtitle(context)),
          const SizedBox(height: 32),
          _buildMainTab(context),
        ],
      ),
    );
  }

  Widget _buildMainTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: colorScheme.primary,
                unselectedLabelColor: Colors.blueGrey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                indicatorColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                tabs: [
                  Tab(text: S.of(context).log_history_game_logs),
                  Tab(text: S.of(context).log_history_auth_logs),
                ],
              ),
            ),
            SizedBox(height: 8),
            Divider(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildGameLogsTab(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildAuthLogsTab(),
                  ),
                ],
              ),
            ),
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameLogsTab() {
    final gameLogs = ref.watch(gameLogServiceProvider);
    final locale = ref.watch(localeProvider).languageCode;

    return Column(
      children: [
        // Fixed header
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).log_history_start_date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).log_history_has_won,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).log_history_has_abandon,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scrollable content
        Expanded(
          child: ListView.separated(
            itemCount: gameLogs.length,
            separatorBuilder: (context, index) =>
                Divider(height: 2, thickness: 1),
            itemBuilder: (context, index) {
              final log = gameLogs[index];
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat.yMMMd(locale).add_Hms().format(log.date),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          log.hasWon ? Icons.check_circle : Icons.remove_circle_outline,
                          color: log.hasWon
                              ? Colors.green
                              : Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          log.hasAbandon ? Icons.check_circle : Icons.remove_circle_outline,
                          color: log.hasAbandon
                              ? Colors.red
                              : Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuthLogsTab() {
    final authLogs = ref.watch(authLogServiceProvider);
    final locale = ref.watch(localeProvider).languageCode;

    return Column(
      children: [
        // Fixed header
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).log_history_login_time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).log_history_logout_time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).log_history_device_type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scrollable content
        Expanded(
          child: ListView.separated(
            itemCount: authLogs.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 2, thickness: 1),
            itemBuilder: (context, index) {
              final log = authLogs[index];
              String deviceTypeDisplay = 'N/A';
              if (log.deviceType != null) {
                if (log.deviceType == 'desktop') {
                  deviceTypeDisplay = S.of(context).log_history_desktop;
                } else if (log.deviceType == 'android') {
                  deviceTypeDisplay = S.of(context).log_history_android;
                } else {
                  deviceTypeDisplay = log.deviceType!;
                }
              }
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat.yMMMd(locale)
                              .add_Hms()
                              .format(log.loginTime),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          log.logoutTime != null
                              ? DateFormat.yMMMd(locale)
                                  .add_Hms()
                                  .format(log.logoutTime!)
                              : "-",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          deviceTypeDisplay == 'N/A' ? "-" : deviceTypeDisplay,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
