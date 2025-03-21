import 'package:flutter/material.dart';

class AppFunctions {
  static snackMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
