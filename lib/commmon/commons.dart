import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Commons {
  static final logger = Logger(
    printer: PrettyPrinter(),
  );

  static final loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static showToast({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
