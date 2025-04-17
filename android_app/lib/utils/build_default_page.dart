import 'package:android_app/widgets/chat_widgets/chat.dart';
import 'package:android_app/widgets/top_bar_widgets/header_widget.dart';
import 'package:android_app/widgets/themed_scaffold.dart';
import 'package:flutter/material.dart';

Widget buildDefaultPage(Widget content) {
  return ThemedScaffold(
    appBar: const HeaderWidget(),
    body: SafeArea(
      child: Column(
        children: [

          Expanded(
            child: Stack(
              children: [
                content,
                const ChatWidget(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
