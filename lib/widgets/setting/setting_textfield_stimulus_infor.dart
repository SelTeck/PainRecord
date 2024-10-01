import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingTextfieldStimulusInfor extends StatelessWidget {
  final String content, hint;
  final TextEditingController controller;

  const SettingTextfieldStimulusInfor(
      {super.key,
      required this.content,
      required this.hint,
      required this.controller});

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
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              showCursor: true,
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the value';
                }
                return null;
              },
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(4),
                // FilteringTextInputFormatter.digitsOnly,
                // FilteringTextInputFormatter.singleLineFormatter,
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
              ],
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
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
                  if (value.characters.length > 1) {
                    controller.text =
                        '${value.substring(0, 1)}.${value.substring(1, value.length)}';
                  }
                } else {
                  if (value.characters.length > 3) {
                    value = value.replaceAll('.', '');
                    controller.text =
                        '${value.substring(0, 2)}.${value.substring(2, value.length)}';
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
