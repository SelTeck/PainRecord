import 'package:flutter/material.dart';
import 'package:pain_record/model/result.dart';

class SettingFutureBuilder extends StatelessWidget {
  final Future<Result> future;
  // final Widget Function() resetCallback;
  final VoidCallback initialzeCallback;
  final VoidCallback clearTextCallback;
  final Widget Function() makeWidgetCallback;

  const SettingFutureBuilder(
      {super.key,
      required this.future,
      required this.initialzeCallback,
      required this.clearTextCallback,
      required this.makeWidgetCallback});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            initialzeCallback.call();
            clearTextCallback.call();

            return makeWidgetCallback.call();
          } else if (snapshot.hasError) {
            initialzeCallback.call();

            return makeWidgetCallback.call();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
