import 'dart:convert';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/theme/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:android_app/models/shop_model.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/themed_scaffold.dart';
import 'package:android_app/services/shop_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/generated/l10n.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  int userBalance = 0;
  bool loading = true;
  String? userId;
  String? errorMessage;

  String currentFilter = 'all';
  List<String> filterOptions = ['all', 'avatar', 'background', 'theme'];

  List<ShopItem> items = [];
  late ShopService _shopService;

  @override
  void initState() {
    super.initState();
    _shopService = ref.read(shopServiceProvider);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final sessionId = ref.read(authServiceProvider).getSessionId();
    
    if (sessionId.isEmpty) {
      setState(() {
        errorMessage = 'Not authenticated';
        loading = false;
      });
      return;
    }
    
    try {
      final response = await http.get(
        Uri.parse('${ref.read(apiUrlProvider)}/accounts/me'),
        headers: {
          'Content-Type': 'application/json',
          'x-session-id': sessionId,
        },
      );
      
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          userId = userData['id'];
        });
        await loadUserData();
      } else {
        setState(() {
          errorMessage = 'Failed to get user data';
          loading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
        loading = false;
      });
    }
  }

  Future<void> loadUserData() async {
    if (userId == null) {
      setState(() {
        errorMessage = 'User ID is not available';
        loading = false;
      });
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      await Future.wait([
        _loadUserCurrency(),
        _loadShopItems(),
      ]);
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _loadUserCurrency() async {
    try {
      final balance = await _shopService.getUserCurrency(userId!);
      setState(() {
        userBalance = balance;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _loadShopItems() async {
    try {
      final shopItems = await _shopService.getShopItems(userId!);
      setState(() {
        items = shopItems;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _buyItem(ShopItem item) async {
    if (item.state != 0 || userBalance < item.price) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });
      
      final newBalance = await _shopService.buyItem(userId!, item.price);
      
      setState(() {
        userBalance = newBalance;
        final itemIndex = items.indexWhere((i) => i.id == item.id);
        if (itemIndex != -1) {
          items[itemIndex].state = 1;
        }
      });
      
      await _shopService.saveShopItems(userId!, items);
    } catch (error) {
      if (mounted) {
        ref.read(notificationServiceProvider).showBottomLeftNotification('Failed to buy item: ${error.toString()}');
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  
  String _getButtonText(ShopItem item) {
    return item.state == 0 ? S.of(context).buy : S.of(context).bought;
  }
  
  Future<void> _handleItemAction(ShopItem item) async {
    if (item.state == 0) {
      await _buyItem(item);
    }
  }

  void _onFilterChange(String filter) {
    setState(() {
      currentFilter = filter;
    });
  }

  List<ShopItem> get _filteredItems {
    if (currentFilter == 'all') {
      return items;
    } else {
      return items.where((item) => item.type == currentFilter).toList();
    }
  }

  String _toSnakeCase(String input) {
    if (input.contains(' ')) {
      return input.replaceAll(' ', '_').toLowerCase();
    } else {
      final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
      return input.split(regex).join('_').toLowerCase();
    }
  }

  String _translatedItemName(BuildContext context, String name) {
    final key = _toSnakeCase(name);
    switch (key) {
      case 'strawberry_background':
        return S.of(context).strawberry_background;
      case 'blueberry_background':
        return S.of(context).blueberry_background;
      case 'orange_background':
        return S.of(context).orange_background;
      case 'watermelon_background':
        return S.of(context).watermelon_background;
      case 'lemon_background':
        return S.of(context).lemon_background;
      case 'strawberry_theme':
        return S.of(context).strawberry_theme;
      case 'blueberry_theme':
        return S.of(context).blueberry_theme;
      case 'watermelon_theme':
        return S.of(context).watermelon_theme;
      case 'premium_lemon_avatar':
        return S.of(context).premium_lemon_avatar;
      case 'premium_orange_avatar':
        return S.of(context).premium_orange_avatar;
      case 'golden_blueberry_avatar':
        return S.of(context).golden_blueberry_avatar;
      case 'golden_lemon_avatar':
        return S.of(context).golden_lemon_avatar;
      case 'golden_watermelon_avatar':
        return S.of(context).golden_watermelon_avatar;
      default:
        return name;
    }
  }

  String _translatedFilterOption(BuildContext context, String option) {
    switch (option) {
      case 'all':
        return S.of(context).all;
      case 'avatar':
        return S.of(context).avatar;
      case 'background':
        return S.of(context).background;
      case 'theme':
        return S.of(context).theme;
      default:
        return option;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildDefaultPage(
      ThemedScaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildShopHeader(),
                    Expanded(
                      child: _buildShopGrid(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildShopHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildFilterControls(),
          ),
          Align(
            alignment: Alignment.center,
            child: _buildShopTitle(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildBalanceContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(8),
        borderColor: Colors.grey,
        selectedBorderColor: Colors.grey,
        borderWidth: 1,
        renderBorder: true,
        fillColor: Colors.grey[300],
        color: Colors.black,
        selectedColor: Colors.black,
        constraints: const BoxConstraints(minWidth: 90, minHeight: 40),
        isSelected: filterOptions.map((option) => option == currentFilter).toList(),
        onPressed: (int index) => _onFilterChange(filterOptions[index]),
        children: filterOptions.map(
          (option) => Text(
            _translatedFilterOption(context, option),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildShopTitle() {    
    return Container(
      alignment: Alignment.center,
      child: Text(
        S.of(context).shop_title,
        style: AppTextStyles.fruitzSubtitle(context),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBalanceContainer() {
    final customColors = Theme.of(context).extension<CustomColors>();
    final logoAsset = customColors?.logoUrl ?? 'assets/images/logo.png';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$userBalance',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(
            width: 15,
            height: 24,
          ),
          Image.asset(
            logoAsset,
            height: 28,
            width: 28,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildShopGrid() {
    if (_filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double aspectRatio;
        
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
          aspectRatio = 0.85; 
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
          aspectRatio = 0.85;
        } else {
          crossAxisCount = 2;
          aspectRatio = 0.9;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return _buildShopItem(item);
          },
        );
      },
    );
  }

  Widget _buildShopItem(ShopItem item) {
    final bool isBought = item.state == 1;
    final customColors = Theme.of(context).extension<CustomColors>();
    final borderColor = Theme.of(context).colorScheme.primary;
    final textColor = customColors?.textColor ?? Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: isBought ? customColors?.boxColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                () {
                  switch (item.type) {
                    case 'avatar':
                      return S.of(context).avatar;
                    case 'background':
                      return S.of(context).background;
                    case 'theme':
                      return S.of(context).theme;
                    default:
                      return item.type;
                  }
                }(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10, 
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Translate the item name using our helper function.
                Text(
                  _translatedItemName(context, item.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${S.of(context).price} ${item.price} ${S.of(context).coins}',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Center( 
                  child: SizedBox(
                    width: 120, 
                    height: 30,
                    child: ElevatedButton(
                      onPressed: (isBought || userBalance < item.price) 
                          ? null 
                          : () => _handleItemAction(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBought 
                            ? Colors.grey
                            : Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                  disabledBackgroundColor: isBought 
                            ? Colors.grey // Grey color when disabled (bought)
                            : Colors.grey.withOpacity(0.5),
                      ),
                      child: Text(
                        _getButtonText(item),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        S.of(context).no_items,
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
