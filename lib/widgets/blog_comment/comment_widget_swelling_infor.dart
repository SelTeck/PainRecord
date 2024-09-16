import 'package:flutter/material.dart';
import 'package:pain_record/widgets/blog_comment/comment_dropdown_swelling.dart';

class CommentWidgetSwellingInfor extends StatelessWidget {
  final CommentDropDwonSwelling _swellDropDownButton = CommentDropDwonSwelling(
    controller: SwellingController(),
  );

  CommentWidgetSwellingInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 4.0, 4.0),
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              '환부의 부기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _swellDropDownButton,
          ),
        ],
      ),
    );
  }

  int get value {
    return _swellDropDownButton.list
        .indexOf(_swellDropDownButton.controller.value);
  }

  set value(index) {
    _swellDropDownButton.controller.value = _swellDropDownButton.list[index];
  }
}
