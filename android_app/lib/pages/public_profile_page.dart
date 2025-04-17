import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/public_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicProfilePage extends ConsumerWidget {
  final String id;

  const PublicProfilePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return buildDefaultPage(
      SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: PublicProfileCard(userId: id),
          ),
        ),
      ),
    );
  }
}
