import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/providers/uri_provider.dart';

String getAvatarSource(String avatarId, WidgetRef ref) {
  final baseUrl = ref.read(apiUrlProvider);
  return '$baseUrl/image/avatar/$avatarId';
}