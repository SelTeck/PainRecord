import 'package:flutter/material.dart';

class CommentButtonUpdate extends StatelessWidget {
  final Function() onPressed;
  const CommentButtonUpdate({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 4.0,
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          onPressed();
        },
        icon: const Icon(
          Icons.upload,
          size: 20,
          color: Colors.white,
        ),
        label: const Text(
          '등록',
          style: TextStyle(color: Colors.white, fontSize: 17.0),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
