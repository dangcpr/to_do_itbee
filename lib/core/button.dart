import 'package:flutter/material.dart';

class AppButtons {
  static Widget circleButton() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        minimumSize: const Size(48, 48),
      ),
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
      onPressed: () {},
    );
  }
}
