import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingDropdownStimulus extends StatelessWidget {
  final List<String> _list = <String>['선택', 'A', 'B', 'C'];
  final StimulusController controller;
  final Function() onChanged;

  SettingDropdownStimulus(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
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
        onChanged: (value) {
          controller.value = value!;
          onChanged();
        },
      ),
    );
  }

  List<String> get list => _list;
}

class StimulusController extends GetxController {
  final RxString _value = '선택'.obs;

  String get value => _value.value;
  set value(String value) {
    _value.value = value;
    update();
  }
}
