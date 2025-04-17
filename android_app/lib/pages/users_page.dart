import 'package:android_app/services/users_service.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(usersProvider.notifier);

    return buildDefaultPage(
      UsersList(),
    );
  }
}
