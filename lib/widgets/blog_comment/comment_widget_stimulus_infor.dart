import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pain_record/widgets/blog_comment/comment_dropdown_stimulator.dart';

class CommentWidgetStimulusInfor extends StatelessWidget {
  final _isStimulusCharge = false.obs;
  final _activeDropDown = CommentDropDownStimulator(
    controller: StimulatorController(),
  );
  final _sleepDropDown = CommentDropDownStimulator(
    controller: StimulatorController(),
  );
  CommentWidgetStimulusInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '척수신경 자극기 설정',
          labelStyle: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    '일상 생활 모드',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: _activeDropDown,
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    '수면 모드',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: _sleepDropDown,
                ),
              ],
            ),
            Obx(
              () => CheckboxListTile(
                value: _isStimulusCharge.value,
                onChanged: (bool? value) {
                  _isStimulusCharge.value = value!;
                },
                title: const Text('척수신경 자극기 충전'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  get activeValue =>
      _activeDropDown.list.indexOf(_activeDropDown.controller.value);
  get sleepValue =>
      _sleepDropDown.list.indexOf(_sleepDropDown.controller.value);
  get isStimulusCharge => _isStimulusCharge.value;

  set activeValue(index) =>
      _activeDropDown.controller.value = _activeDropDown.list[index];
  set sleepValue(index) =>
      _sleepDropDown.controller.value = _sleepDropDown.list[index];
  set isStimulusCharge(value) => _isStimulusCharge.value = value;
}
