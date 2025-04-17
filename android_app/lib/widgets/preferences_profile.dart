import 'package:android_app/generated/l10n.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/language_settings_service.dart';
import 'package:android_app/providers/theme_provider.dart';
import 'package:android_app/main.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_app/providers/uri_provider.dart';
import 'package:go_router/go_router.dart';

class ShopItem {
  final int id;
  final String name;
  final String image;
  final String type;
  final int price;
  final int state;

  ShopItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.price,
    required this.state,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      type: json['type'],
      price: json['price'],
      state: json['state'],
    );
  }
}

class LockedItemDialog extends StatelessWidget {
  const LockedItemDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final boxColor = customColors?.buttonBox ?? Colors.white;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).locked_item_title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).locked_item_message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boxColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    S.of(context).go_to_shop,
                    style: TextStyle(
                      color: customColors?.buttonText ?? Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    S.of(context).cancel,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PreferencesProfileWidget extends ConsumerStatefulWidget {
  const PreferencesProfileWidget({super.key});

  @override
  ConsumerState<PreferencesProfileWidget> createState() =>
      _PreferencesProfileWidgetState();
}

class _PreferencesProfileWidgetState
    extends ConsumerState<PreferencesProfileWidget> {
  List<ShopItem> shopItems = [];
  bool isLoading = true;
  String? userId;

  final Map<String, String> themeAssetToIdentifier = {
    'assets/images/logo.png': 'lemon',
    'assets/images/orangeslogo.png': 'oranges',
    'assets/images/strawberrylogo.png': 'strawberries',
    'assets/images/blueberrylogo1.png': 'blueberries',
    'assets/images/watermelonlogo.png': 'watermelon',
  };

  final Map<String, String> backgroundAssetToIdentifier = {
    'assets/images/none_icon.png': 'none',
    'assets/images/lemonbackground.png': 'lemon',
    'assets/images/orangesbackground.png': 'oranges',
    'assets/images/strawberrybackground.png': 'strawberries',
    'assets/images/blueberrybackground.png': 'blueberries',
    'assets/images/watermelonbackground.png': 'watermelon',
  };

  final Map<String, bool> themeLockStatus = {
    'lemon-theme': false,
    'oranges-theme': false,
    'strawberries-theme': true,
    'blueberries-theme': true,
    'watermelon-theme': true,
  };

  final Map<String, bool> backgroundLockStatus = {
    'none': false,
    'lemon': true,
    'oranges': true,
    'strawberries': true,
    'blueberries': true,
    'watermelon': true,
  };

  @override
  void initState() {
    super.initState();
    _loadUserShop();
  }

  Future<void> _loadUserShop() async {
    setState(() {
      isLoading = true;
    });

    final sessionId = ref.read(authServiceProvider).getSessionId();

    final userResponse = await http.get(
      Uri.parse('${ref.read(apiUrlProvider)}/accounts/me'),
      headers: {
        'Content-Type': 'application/json',
        'x-session-id': sessionId,
      },
    );

    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      setState(() {
        userId = userData['id'];
      });
    } else {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final apiUrl = ref.read(apiUrlProvider);
      final shopResponse = await http.get(
        Uri.parse('$apiUrl/shop/$userId'),
      );

      if (shopResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(shopResponse.body);
        if (responseData.containsKey('items') &&
            responseData['items'] is List) {
          final List<dynamic> items = responseData['items'];
          shopItems = items.map((item) => ShopItem.fromJson(item)).toList();
          _updateLockedStates(shopItems);
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateLockedStates(List<ShopItem> items) {
    themeLockStatus['lemon-theme'] = false;
    themeLockStatus['oranges-theme'] = false;
    themeLockStatus['strawberries-theme'] = true;
    themeLockStatus['blueberries-theme'] = true;
    themeLockStatus['watermelon-theme'] = true;

    backgroundLockStatus['none'] = false;
    backgroundLockStatus['lemon'] = true;
    backgroundLockStatus['oranges'] = true;
    backgroundLockStatus['strawberries'] = true;
    backgroundLockStatus['blueberries'] = true;
    backgroundLockStatus['watermelon'] = true;

    for (var item in items) {
      if (item.type == 'theme') {
        if (item.name.toLowerCase().contains('strawberry')) {
          themeLockStatus['strawberries-theme'] =
              item.state == 1 ? false : true;
        } else if (item.name.toLowerCase().contains('blueberry')) {
          themeLockStatus['blueberries-theme'] =
              item.state == 1 ? false : true;
        } else if (item.name.toLowerCase().contains('watermelon')) {
          themeLockStatus['watermelon-theme'] =
              item.state == 1 ? false : true;
        }
      } else if (item.type == 'background') {
        if (item.name.toLowerCase().contains('strawberry')) {
          backgroundLockStatus['strawberries'] =
              item.state == 1 ? false : true;
        } else if (item.name.toLowerCase().contains('blueberry')) {
          backgroundLockStatus['blueberries'] =
              item.state == 1 ? false : true;
        } else if (item.name.toLowerCase().contains('lemon')) {
          backgroundLockStatus['lemon'] =
              item.state == 1 ? false : true;
        } else if (item.name.toLowerCase().contains('orange')) {
          backgroundLockStatus['oranges'] =
              item.state == 1 ? false : true;
        } else if (item.name.toLowerCase().contains('watermelon')) {
          backgroundLockStatus['watermelon'] =
              item.state == 1 ? false : true;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final themeService = ref.watch(themeServiceProvider);
    final currentTheme = themeService.currentTheme;
    final currentBackground = themeService.currentBackground;
    final customColors = Theme.of(context).extension<CustomColors>();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 450,
                height: 560,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: customColors?.boxColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        S.of(context).information_profile_select_theme,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _ThemeOption(
                          themeName: 'lemon-theme',
                          logoUrl: 'assets/images/logo.png',
                          isSelected: currentTheme == 'lemon-theme',
                          isLocked: themeLockStatus['lemon-theme'] ?? false,
                          onTap: () => _handleThemeClick('lemon-theme'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _ThemeOption(
                          themeName: 'oranges-theme',
                          logoUrl: 'assets/images/orangeslogo.png',
                          isSelected: currentTheme == 'oranges-theme',
                          isLocked: themeLockStatus['oranges-theme'] ?? false,
                          onTap: () => _handleThemeClick('oranges-theme'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _ThemeOption(
                          themeName: 'strawberries-theme',
                          logoUrl: 'assets/images/strawberrylogo.png',
                          isSelected: currentTheme == 'strawberries-theme',
                          isLocked: themeLockStatus['strawberries-theme'] ?? true,
                          onTap: () => _handleThemeClick('strawberries-theme'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _ThemeOption(
                          themeName: 'blueberries-theme',
                          logoUrl: 'assets/images/blueberrylogo1.png',
                          isSelected: currentTheme == 'blueberries-theme',
                          isLocked: themeLockStatus['blueberries-theme'] ?? true,
                          onTap: () => _handleThemeClick('blueberries-theme'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _ThemeOption(
                          themeName: 'watermelon-theme',
                          logoUrl: 'assets/images/watermelonlogo.png',
                          isSelected: currentTheme == 'watermelon-theme',
                          isLocked: themeLockStatus['watermelon-theme'] ?? true,
                          onTap: () => _handleThemeClick('watermelon-theme'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        S.of(context).personal_profile_language_choice,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LanguageRadioOption(
                          label: S.of(context).personal_profile_language_english,
                          languageCode: 'en',
                          isSelected: currentLocale.languageCode == 'en',
                          onTap: () => _updateLanguage(ref, 'en'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        const SizedBox(width: 30),
                        _LanguageRadioOption(
                          label: S.of(context).personal_profile_language_french,
                          languageCode: 'fr',
                          isSelected: currentLocale.languageCode == 'fr',
                          onTap: () => _updateLanguage(ref, 'fr'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              Container(
                width: 450,
                height: 560,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: customColors?.boxColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        S.of(context).information_profile_select_background,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _BackgroundOption(
                          backgroundName: 'none',
                          backgroundUrl: 'assets/images/none_icon.png',
                          isSelected: currentBackground == 'none',
                          isLocked: backgroundLockStatus['none'] ?? false,
                          onTap: () => _handleBackgroundClick('none'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _BackgroundOption(
                          backgroundName: 'lemon',
                          backgroundUrl: 'assets/images/lemonbackground.png',
                          isSelected: currentBackground == 'lemon',
                          isLocked: backgroundLockStatus['lemon'] ?? true,
                          onTap: () => _handleBackgroundClick('lemon'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _BackgroundOption(
                          backgroundName: 'oranges',
                          backgroundUrl: 'assets/images/orangesbackground.png',
                          isSelected: currentBackground == 'oranges',
                          isLocked: backgroundLockStatus['oranges'] ?? true,
                          onTap: () => _handleBackgroundClick('oranges'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _BackgroundOption(
                          backgroundName: 'strawberries',
                          backgroundUrl: 'assets/images/strawberrybackground.png',
                          isSelected: currentBackground == 'strawberries',
                          isLocked: backgroundLockStatus['strawberries'] ?? true,
                          onTap: () => _handleBackgroundClick('strawberries'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _BackgroundOption(
                          backgroundName: 'blueberries',
                          backgroundUrl: 'assets/images/blueberrybackground.png',
                          isSelected: currentBackground == 'blueberries',
                          isLocked: backgroundLockStatus['blueberries'] ?? true,
                          onTap: () => _handleBackgroundClick('blueberries'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                        _BackgroundOption(
                          backgroundName: 'watermelon',
                          backgroundUrl: 'assets/images/watermelonbackground.png',
                          isSelected: currentBackground == 'watermelon',
                          isLocked: backgroundLockStatus['watermelon'] ?? true,
                          onTap: () => _handleBackgroundClick('watermelon'),
                          boxColor: customColors?.boxColor ?? Colors.white,
                        ),
                      ],
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

  Future<void> _updateLanguage(WidgetRef ref, String languageCode) async {
    final languageService = ref.read(languageSettingServiceProvider);
    final userId = ref.read(userInfoServiceProvider).id;
    ref.read(localeProvider.notifier).state = Locale(languageCode);
    await languageService.updateUserLanguage(userId, languageCode);
  }

  void _updateTheme(WidgetRef ref, String themeName) {
    if (themeLockStatus[themeName] == true) return;
    final themeService = ref.read(themeServiceProvider);
    themeService.setTheme(themeName);
  }

  void _updateBackground(WidgetRef ref, String backgroundName) {
    if (backgroundLockStatus[backgroundName] == true) return;
    final themeService = ref.read(themeServiceProvider);
    themeService.setBackground(backgroundName);
  }

  void _handleThemeClick(String themeName) {
    if (themeLockStatus[themeName] == true) {
      _openLockedItemDialog();
    } else {
      _updateTheme(ref, themeName);
    }
  }

  void _handleBackgroundClick(String backgroundName) {
    if (backgroundLockStatus[backgroundName] == true) {
      _openLockedItemDialog();
    } else {
      _updateBackground(ref, backgroundName);
    }
  }
Future<void> _openLockedItemDialog() async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const LockedItemDialog(),
  );

  if (result == true) {
    navigatorKey.currentContext?.go('/shop');
  }
}
}

class _ThemeOption extends StatelessWidget {
  final String themeName;
  final String logoUrl;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;
  final Color boxColor;

  const _ThemeOption({
    required this.themeName,
    required this.logoUrl,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
    required this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final accentColor = customColors?.accentColor;
    final textColor = customColors?.textColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? (textColor ?? Colors.black) : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          logoUrl,
                          fit: BoxFit.cover,
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (isLocked)
              Positioned.fill(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundOption extends StatelessWidget {
  final String backgroundName;
  final String backgroundUrl;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;
  final Color boxColor;

  const _BackgroundOption({
    required this.backgroundName,
    required this.backgroundUrl,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
    required this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final accentColor = customColors?.accentColor;
    final textColor = customColors?.textColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? (textColor ?? Colors.black) : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          backgroundUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (isLocked)
              Positioned.fill(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRadioOption extends StatelessWidget {
  final String label;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;
  final Color boxColor;

  const _LanguageRadioOption({
    required this.label,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
    required this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final accentColor = customColors?.accentColor;
    final textColor = customColors?.textColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? (textColor ?? Colors.black) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
