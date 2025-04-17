import 'package:android_app/pages/personal_profile_friends_tab.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/information_profile.dart';
import 'package:android_app/widgets/preferences_profile.dart';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/widgets/sidebar_profile.dart';
import 'package:android_app/widgets/themed_scaffold.dart';
import 'package:android_app/widgets/personal_achivement.dart';

class PersonalProfilePage extends ConsumerStatefulWidget {
  final String tab;

  const PersonalProfilePage({super.key, this.tab = 'information'});

  @override
  ConsumerState<PersonalProfilePage> createState() =>
      _PersonalProfilePageState();
}

class _PersonalProfilePageState extends ConsumerState<PersonalProfilePage> {
  late String currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = widget.tab;
  }

  void handleTabChange(String newTab) {
    setState(() {
      currentTab = newTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildDefaultPage(ThemedScaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SidebarProfile(
                  currentPage: currentTab,
                  setActivePage: handleTabChange,
                ),
                Expanded(
                  child: Container(
                    child: currentTab == 'information'
                        ? const PersonalInformation()
                        : currentTab == 'preferences'
                            ? const PreferencesProfileWidget()
                            : currentTab == 'friends'
                                ? const PersonalProfileFriendsTab()
                                : currentTab == 'accomplishments'
                                ? PersonalAchievementsWidget(
                                  userId: ref.watch(userInfoServiceProvider).id,
                                )
                                : Center(
                                    child: Text(
                                      '${S.of(context).personal_profile_selected_page} $currentTab',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
