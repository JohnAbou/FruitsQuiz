import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopupState {
  final Widget? widget;
  final double opacity;

  const PopupState({this.widget, this.opacity = 0});
}

class PopupNotifier extends StateNotifier<PopupState> {
  PopupNotifier() : super(const PopupState());

  void show(Widget popup, opacity) {
    state = PopupState(widget: popup, opacity: opacity);
  }

  void hide() {
    state = const PopupState();
  }
}

final popupProvider = StateNotifierProvider<PopupNotifier, PopupState>((ref) {
  return PopupNotifier();
});
