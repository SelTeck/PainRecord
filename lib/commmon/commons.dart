import 'package:flutter/material.dart';

class Commons {
  static showToast({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
