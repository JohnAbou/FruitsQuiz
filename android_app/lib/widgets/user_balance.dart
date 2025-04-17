import 'package:android_app/services/currency_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/theme/custom_colors.dart';

class BalanceContainer extends ConsumerWidget {
  const BalanceContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(currencyProvider);
    
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
            '$balance',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Container(
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
}