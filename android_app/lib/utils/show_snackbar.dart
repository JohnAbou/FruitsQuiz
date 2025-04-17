import 'package:android_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

showSnackBar(String message) {
  var context = navigatorKey.currentContext;
  if (context == null) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}
