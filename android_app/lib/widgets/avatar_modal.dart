import 'dart:convert';
import 'dart:io';
import 'package:android_app/models/shop_model.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:android_app/services/shop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/utils/avatar.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:go_router/go_router.dart';  

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

class AvatarModal extends ConsumerStatefulWidget {
  const AvatarModal({super.key});

  @override
  ConsumerState<AvatarModal> createState() => _AvatarModalState();
}

class _AvatarModalState extends ConsumerState<AvatarModal> {
  String? selectedAvatar;
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();
  List<Map<String, dynamic>> premiumAvatars = [];
  bool isLoadingPremiumAvatars = true;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadPremiumAvatars();
  }

  Future<void> _loadPremiumAvatars() async {
    final sessionId = ref.read(authServiceProvider).getSessionId();

    final response = await http.get(
      Uri.parse('${ref.read(apiUrlProvider)}/accounts/me'),
      headers: {
        'Content-Type': 'application/json',
        'x-session-id': sessionId,
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      userId = userData['id'];
    }

    try {
      final shopItems = await ref.read(shopServiceProvider).getShopItems(userId);
      setState(() {
        premiumAvatars = [
          {
            "id": 'premium_lemon_avatar',
            "image": 'assets/avatars/premium_lemon_avatar.png',
            "locked": !_isPurchased(shopItems, 'Premium Lemon Avatar')
          },
          {
            "id": 'premium_orange_avatar',
            "image": 'assets/avatars/premium_orange_avatar.png',
            "locked": !_isPurchased(shopItems, 'Premium Orange Avatar')
          },
          {
            "id": 'golden_blueberry_avatar',
            "image": 'assets/avatars/golden_blueberry_avatar.png',
            "locked": !_isPurchased(shopItems, 'Golden Blueberry Avatar')
          },
          {
            "id": 'golden_lemon_avatar',
            "image": 'assets/avatars/golden_lemon_avatar.png',
            "locked": !_isPurchased(shopItems, 'Golden Lemon Avatar')
          },
          {
            "id": 'golden_watermelon_avatar',
            "image": 'assets/avatars/golden_watermelon_avatar.png',
            "locked": !_isPurchased(shopItems, 'Golden Watermelon Avatar')
          },
        ];
        isLoadingPremiumAvatars = false;
      });
    } catch (err) {
      setState(() {
        isLoadingPremiumAvatars = false;
      });
    }
  }

  bool _isPurchased(List<ShopItem> items, String name) {
    return items.any((item) => item.name == name && item.state == 1);
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        pickedImage = image;
        selectedAvatar = null;
      });
    }
  }

  Future<void> saveAvatar() async {
    if (selectedAvatar != null) {
      await ref.read(userInfoServiceProvider.notifier).setPredefinedAvatar(selectedAvatar!);
    } else if (pickedImage != null) {
      await ref.read(userInfoServiceProvider.notifier).uploadUserAvatarFile(pickedImage!);
    }
    if (mounted) Navigator.pop(context);
  }

Future<void> _handleLockedAvatarClick() async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const LockedItemDialog(),
  );

  if (result == true) {
    Navigator.pop(context);
    context.go('/shop');
  }
}

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final user = ref.watch(userInfoServiceProvider);
    final avatars = user.avatarIds;

    return Dialog(
      backgroundColor: customColors.chatBox,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).change_avatar,
                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).choose_avatar,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: avatars.map((avatarId) {
                      final isSelected = selectedAvatar == avatarId;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatarId;
                            pickedImage = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? customColors.sidebarText : Colors.transparent,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(getAvatarSource(avatarId, ref)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).premium_avatar,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (isLoadingPremiumAvatars)
                    const Center(child: CircularProgressIndicator())
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: premiumAvatars.map((avatar) {
                        final isSelected = selectedAvatar == avatar['id'];
                        final isLocked = avatar['locked'];

                        return GestureDetector(
                          onTap: isLocked
                              ? _handleLockedAvatarClick 
                              : () {
                                  setState(() {
                                    selectedAvatar = avatar['id'];
                                    pickedImage = null;
                                  });
                                },
                          child: Stack(
                            children: [
                              MouseRegion(
                                cursor: isLocked
                                    ? SystemMouseCursors.click 
                                    : SystemMouseCursors.click,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected ? customColors.sidebarText : Colors.transparent,
                                      width: 3,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: ColorFiltered(
                                    colorFilter: isLocked
                                        ? const ColorFilter.matrix(<double>[
                                            0.2126, 0.7152, 0.0722, 0, 0,
                                            0.2126, 0.7152, 0.0722, 0, 0,
                                            0.2126, 0.7152, 0.0722, 0, 0,
                                            0,      0,      0,      1, 0,
                                          ])
                                        : const ColorFilter.mode(
                                            Colors.transparent, BlendMode.saturation),
                                    child: Opacity(
                                      opacity: isLocked ? 0.7 : 1.0,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AssetImage(avatar['image']),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (isLocked)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800]!.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.grey.withOpacity(0.4),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    S.of(context).Or,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.upload, color: Colors.white, size: 18),
                    label: Text(S.of(context).Upload, style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.sidebarText,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    label: Text(S.of(context).Camera, style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.sidebarText,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              if (pickedImage != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.file(
                      File(pickedImage!.path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.buttonBox,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text(
                      S.of(context).cancel,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (selectedAvatar != null || pickedImage != null) ? saveAvatar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (selectedAvatar != null || pickedImage != null)
                          ? customColors.buttonBox
                          : const Color(0xFFCCCCCC),
                      foregroundColor: (selectedAvatar != null || pickedImage != null)
                          ? Colors.black
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text(S.of(context).save),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}