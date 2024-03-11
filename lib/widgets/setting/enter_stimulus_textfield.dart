import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterStimulusTextfield extends StatelessWidget {
  final String content, hint;
  final TextEditingController controller;

  const EnterStimulusTextfield(
      {Key? key,
      required this.content,
      required this.hint,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
            margin: const EdgeInsets.only(right: 8.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              // keyboardType: TextInputType.number,
              showCursor: true,
              controller: controller,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(4),
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.singleLineFormatter,
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
              ],
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: EdgeInsets.zero, // align center
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
              onChanged: (value) {
                if (!value.contains('.')) {
                  if (value.characters.length > 2) {
                    controller.text = '';
                    controller.text = '${value.substring(0, 2)}.';
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
