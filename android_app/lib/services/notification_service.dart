import 'package:android_app/generated/l10n.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/popup_notifier.dart';
import 'package:android_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  void showPopup(Widget widget, double opacity) {
    _ref.read(popupProvider.notifier).show(widget, opacity);
  }

  void hidePopup() {
    _ref.read(popupProvider.notifier).hide();
  }

  void showInformationCardPopup({
    required String message,
  }) {
    showPopup(
      Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => hidePopup(),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    S.current.information_modal_understood,
                    style: TextStyle(color: Theme.of(navigatorKey.currentContext!).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      0.32,
    );
  }

  void showConfirmationCardPopup({
    required String message,
    required Function() onConfirm,
    required Function() onCancel,
  }) {
    showPopup(
      Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        hidePopup();
                        onConfirm();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(navigatorKey.currentContext!)
                            .colorScheme
                            .primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(S.current.yes, style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        hidePopup();
                        onCancel();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(navigatorKey.currentContext!).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(S.current.no, style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      0.32,
    );
  }

  void showTopRightNotification({
    required String message,
    required IconData icon,
    VoidCallback? actionCallback,
    int autoHideDuration = 4000,
  }) {
    var content = NotificationWidget(
      message: message,
      icon: icon,
      arrowCallback: actionCallback,
      onDismiss: hidePopup,
    );

    showPopup(
        Positioned(
          top: 35,
          right: 10,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 375),
            child: content,
          ),
        ),
        0);

    if (autoHideDuration > 0) {
      Future.delayed(Duration(milliseconds: autoHideDuration), hidePopup);
    }
  }

  void showBottomLeftNotification(String message) {
    showPopup(
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF323232),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => hidePopup(),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: Theme.of(navigatorKey.currentContext!)
                        .colorScheme
                        .secondary,
                  ),
                  child: Text(S.current.notification_close_button),
                ),
              ],
            ),
          ),
        ),
        0);

    Future.delayed(Duration(milliseconds: 2000), hidePopup);
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});
