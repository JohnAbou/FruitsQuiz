import 'package:android_app/models/avatar_modified_event.dart';
import 'package:android_app/models/user_stats.dart';
import 'package:android_app/models/username_modified_event.dart';
import 'package:android_app/services/user_stats_service.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/theme/app_styles.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/utils/time.dart';
import 'package:android_app/widgets/profile_avatar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  int _sortColumnIndex = -1;
  bool _sortAscending = false;

  UsersService? usersService;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.refresh(allUsersStatsProvider));

    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    usersService = ref.read(usersProvider.notifier);

    usersService?.avatarModified.subscribe(onAvatarModified);
    usersService?.usernameModified.subscribe(onUsernameModified);
  }

  @override
  void dispose() {
    usersService?.avatarModified.unsubscribe(onAvatarModified);
    usersService?.usernameModified.unsubscribe(onUsernameModified);
    super.dispose();
  }

  void onAvatarModified(AvatarModifiedEvent event) {
    final _ = ref.refresh(allUsersStatsProvider);
  }

  void onUsernameModified(UsernameModifiedEvent event) {
    final _ = ref.refresh(allUsersStatsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final usersStatsAsync = ref.watch(allUsersStatsProvider);

    return buildDefaultPage(
      Column(
        children: [
          const SizedBox(height: 32),
          Text(
            S.of(context).leaderboardPage_Leaderboard,
            style: AppTextStyles.fruitzSubtitle(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
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
              child: usersStatsAsync.when(
                data: (usersList) {
                  final sortedData = _sortData(List.from(usersList));
                  return _buildLeaderboardTable(sortedData);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading leaderboard: $error'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<UserWithStats> _sortData(List<UserWithStats> data) {
    dynamic Function(UserWithStats)? getField;
    
    if (_sortColumnIndex == -1) {
      getField = (user) => user.userStats.totalGameWon;
      data.sort((a, b) {
        final aValue = getField!(a);
        final bValue = getField(b);
        final comparison =
            Comparable.compare(aValue as Comparable, bValue as Comparable);
        return -comparison;
      });
      return data;
    }
    
    switch (_sortColumnIndex) {
      case 2:
        getField = (user) => user.userStats.totalGameWon;
        break;
      case 3:
        getField = (user) => user.userStats.totalGameTime;
        break;
      case 4:
        getField = (user) => user.userStats.bestWinStreak;
        break;
      case 5:
        getField = (user) => user.userStats.currentWinStreak;
        break;
      case 6:
        getField = (user) => user.userStats.totalPoints;
        break;
      case 7:
        getField = (user) => user.userStats.coinGained;
        break;
      case 8:
        getField = (user) => user.userStats.coinSpent;
        break;
      default:
        getField = (user) => user.userStats.totalGameWon;
    }

    data.sort((a, b) {
      final aValue = getField!(a);
      final bValue = getField(b);
      final comparison =
          Comparable.compare(aValue as Comparable, bValue as Comparable);
      return _sortAscending ? comparison : -comparison;
    });
    return data;
  }

  Widget _buildLeaderboardTable(List<UserWithStats> users) {
    return LayoutBuilder(builder: (context, constraints) {
      final tableWidth = constraints.maxWidth;

      return Column(
        children: [
          Container(
            color: Colors.white,
            child: _buildHeaderRow(tableWidth),
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                thickness: WidgetStateProperty.all(6),
                radius: const Radius.circular(8),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: tableWidth,
                    child: _buildDataRows(users, tableWidth),
                  ),
                ),
              ),
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
      );
    });
  }

  Widget _buildHeaderRow(double tableWidth) {
    const double rankWidth = 60.0;
    const double userWidth = 170.0;
    final double otherColumnsWidth = (tableWidth > (rankWidth + userWidth))
        ? (tableWidth - rankWidth - userWidth) / 7
        : 100.0;

    return Container(
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade300, width: 2.0)),
      ),
      child: Row(
        children: [
          _buildHeaderCell(S.of(context).leaderboardPage_Rank, rankWidth,
              null), // Rank not sortable
          _buildHeaderCell(S.of(context).leaderboardPage_User, userWidth,
              null), // User not sortable by default
          _buildHeaderCell(
              S.of(context).leaderboardPage_GamesWon, otherColumnsWidth, 2),
          _buildHeaderCell(
              S.of(context).leaderboardPage_GameTime, otherColumnsWidth, 3),
          _buildHeaderCell(
              S.of(context).leaderboardPage_BestStreak, otherColumnsWidth, 4),
          _buildHeaderCell(S.of(context).leaderboardPage_CurrentStreak,
              otherColumnsWidth, 5),
          _buildHeaderCell(
              S.of(context).leaderboardPage_Points, otherColumnsWidth, 6),
          _buildHeaderCell(
              S.of(context).leaderboardPage_CoinsGained, otherColumnsWidth, 7),
          _buildHeaderCell(
              S.of(context).leaderboardPage_CoinsSpent, otherColumnsWidth, 8),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width, int? columnIndex) {
    final bool isSortable = columnIndex != null;
    // Only show arrow when a column is actively sorted (no default sort state)
    final bool showSortArrow = isSortable && _sortColumnIndex == columnIndex;

    return SizedBox(
      width: width,
      height: 64, // Standard header height
      child: InkWell(
        // Only allow taps if the column is sortable
        onTap: isSortable ? () => _handleSort(columnIndex) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.left,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    if (showSortArrow)
                      Icon(
                        _sortAscending ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRows(List<UserWithStats> users, double tableWidth) {
    const double rankWidth = 60.0;
    const double userWidth = 170.0;
    final double otherColumnsWidth = (tableWidth > (rankWidth + userWidth))
        ? (tableWidth - rankWidth - userWidth) / 7
        : 100.0;

    return Column(
      children: List.generate(users.length, (index) {
        final user = users[index];
        final rank = index + 1;

        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              _buildDataCell('$rank', rankWidth),
              _buildDataCell(
                '',
                userWidth,
                customWidget: Row(
                  children: [
                    ProfileAvatarIconWidget(
                      user: ref.watch(userProviderById(user.id)),
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.username,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDataCell(
                  '${user.userStats.totalGameWon}', otherColumnsWidth),
              _buildDataCell(
                  formatTime(user.userStats.totalGameTime), otherColumnsWidth),
              _buildDataCell(
                  '${user.userStats.bestWinStreak}', otherColumnsWidth),
              _buildDataCell(
                  '${user.userStats.currentWinStreak}', otherColumnsWidth),
              _buildDataCell(
                  '${user.userStats.totalPoints}', otherColumnsWidth),
              _buildDataCell(
                  '${user.userStats.coinGained}', otherColumnsWidth),
              _buildDataCell('${user.userStats.coinSpent}', otherColumnsWidth),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDataCell(String text, double width, {Widget? customWidget}) {
    return SizedBox(
      width: width,
      height: 56.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Align(
          alignment: customWidget != null ? Alignment.centerLeft : Alignment.center,
          child: customWidget ??
              Text(
                text,
                style: TextStyle(
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
        ),
      ),
    );
  }

  void _handleSort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        if (_sortAscending) {
          _sortColumnIndex = -1;
        } else {
          _sortAscending = true;
        }
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = false;
      }
    });
  }
}
