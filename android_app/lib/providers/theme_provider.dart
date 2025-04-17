import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/preferences_service.dart';

final themeServiceProvider = ChangeNotifierProvider<PreferencesService>((ref) {
  final apiUrl = ref.read(apiUrlProvider);

  return PreferencesService(authService: ref.read(authServiceProvider), baseUrl: apiUrl);

});
