import 'package:flutter/material.dart';

class SnackBarHelper {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String title, {Color color = Colors.green, Duration duration=const Duration(seconds: 2)}) {
    
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: color,
        duration: duration,
        // padding: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
