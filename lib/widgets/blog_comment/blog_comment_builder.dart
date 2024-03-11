import 'package:flutter/material.dart';
import 'package:pain_record/model/result.dart';

class BlogCommentBuilder extends StatelessWidget {
  final Future<Result> future;
  final VoidCallback initialzeCallback;
  const BlogCommentBuilder(
      {super.key, required this.future, required this.initialzeCallback});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          // initialzeCallback.call();

          if (snapshot.hasData) {
          } else if (snapshot.hasError) {}

          // return const CircleProgressView(message: 'Uploading....');
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
