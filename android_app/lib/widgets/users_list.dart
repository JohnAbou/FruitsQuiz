import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/widgets/friend_widgets/friend_request_control_line_widget.dart';
import 'package:android_app/widgets/profile_avatar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/models/user.dart';
import 'package:android_app/widgets/themed_scaffold.dart';

class UsersList extends ConsumerStatefulWidget {
  const UsersList({super.key});

  @override
  _UsersListWidgetState createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends ConsumerState<UsersList> {
  final TextEditingController _filterController = TextEditingController();
  String _filterText = '';

  @override
  void initState() {
    super.initState();
    _filterController.addListener(() {
      setState(() {
        _filterText = _filterController.text;
      });
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  List<User> _getFilteredUsers(List<User> users) {
    if (_filterText.isEmpty) {
      return users;
    }
    return users
        .where((user) =>
            user.username.toLowerCase().contains(_filterText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(nonFriendUsersProvider);
    final filteredUsers = _getFilteredUsers(users);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ThemedScaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.5,
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
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      S.of(context).users_list_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _filterController,
                  decoration: InputDecoration(
                    labelText: S.of(context).users_list_filter_label,
                    labelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: filteredUsers.isEmpty
                      ? Center(
                          child: Text(
                            S.of(context).users_list_no_result,
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: index != filteredUsers.length - 1
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.08),
                                          width: 1,
                                        ),
                                      )
                                    : null,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                leading: ProfileAvatarIconWidget(user: user),
                                title: Text(
                                  user.username,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FriendRequestControlLineWidget(
                                        username: user.username),
                                  ],
                                ),
                                hoverColor: Colors.black.withOpacity(0.03),
                              ),
                            );
                          },
                        ),
                ),
              ),
              Container(
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.02),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
