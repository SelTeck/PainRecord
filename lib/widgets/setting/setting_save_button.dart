import 'package:flutter/material.dart';

class SettingSaveButton extends StatelessWidget {
  final Function onPressed;
  const SettingSaveButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        // onPressed: () {
        //   Commons.logger.i('SelTeck, ElevatedButton onPressed');
        //   onPressed.call();
        // },
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          '저장',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
