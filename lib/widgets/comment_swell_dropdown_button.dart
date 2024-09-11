import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentSwellDropdownButton extends StatelessWidget {
  final List<String> _list = <String>['안 부음', '조금 부음', '제법 부음', '많이 부음'];
  final SwellingController controller;

  List<String> get list => _list;
  CommentSwellDropdownButton({super.key, required this.controller});

  @override
  Widget build(Object context) {
    return Obx(
      () => DropdownButton(
        isExpanded: true,
        value: controller.value,
        items: _list.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (String? value) {
          controller.value = value!;
        },
      ),
    );
  }
}

class SwellingController extends GetxController {
  final RxString _value = '안 부음'.obs;

  String get value => _value.value;
  set value(String value) => _value.value = value;
}
