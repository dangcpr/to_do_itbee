import 'package:flutter/material.dart';

class AppFunctions {
  static void snackMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
