import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentWidgetMedicineInfor extends StatelessWidget {
  final _isTakeMorning = false.obs;
  final _isTakeDinner = false.obs;
  final _isTakePatch = false.obs;
  final _isAntiAnalgesic = false.obs;
  final _isNarcoticAnalgesic = false.obs;

  CommentWidgetMedicineInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '약 복용 특이 사항',
          labelStyle: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        child: Column(
          children: [
            Obx(
              () => CheckboxListTile(
                value: _isTakeMorning.value,
                onChanged: (bool? value) {
                  _isTakeMorning.value = value!;
                },
                title: const Text('아침 약 복용'),
                subtitle: const Text('울트라셋 한 알 복용'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: _isTakeDinner.value,
                onChanged: (bool? value) {
                  _isTakeDinner.value = value!;
                },
                title: const Text('저녁 약 복용'),
                subtitle: const Text('울트라셋 한 알 복용'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: _isTakePatch.value,
                onChanged: (bool? value) {
                  _isTakePatch.value = value!;
                },
                title: const Text('뉴도탑 패치 사용'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: _isAntiAnalgesic.value,
                onChanged: (bool? value) {
                  _isAntiAnalgesic.value = value!;
                },
                title: const Text('소염진통제 복용'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: _isNarcoticAnalgesic.value,
                onChanged: (bool? value) {
                  _isNarcoticAnalgesic.value = value!;
                },
                title: const Text('마약성 진통제 복용'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  set isTakeMorning(value) => _isTakeMorning.value = value;
  set isTakeDinner(value) => _isTakeDinner.value = value;
  set isTakePatch(value) => _isTakePatch.value = value;
  set isAntiAnalgesic(value) => _isAntiAnalgesic.value = value;
  set isNarcoticAnalgesic(value) => _isNarcoticAnalgesic.value = value;

  bool get isTakeMorning => _isTakeMorning.value;
  bool get isTakeDinner => _isTakeMorning.value;
  bool get isTakePatch => _isTakePatch.value;
  bool get isAntiAnalgesic => _isAntiAnalgesic.value;
  bool get isNarcoticAnalgesic => _isNarcoticAnalgesic.value;
}
