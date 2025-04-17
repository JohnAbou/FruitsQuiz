import 'package:android_app/widgets/public_profile_card.dart';
import 'package:flutter/material.dart';

class PublicProfileModal extends StatelessWidget {
  final String userId;

  const PublicProfileModal({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: PublicProfileCard(userId: userId),
      ),
    );
  }
}
