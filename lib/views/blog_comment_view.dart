import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pain_record/model/commentinfo.dart';
import 'package:pain_record/provider/comment_provider.dart';
import 'package:pain_record/widgets/comment_stimulator_dropdown_button.dart';
import 'package:pain_record/widgets/comment_swell_dropdown_button.dart';
import 'package:pain_record/widgets/comment_update_button.dart';

class BlogCommentView extends StatefulWidget {
  final blogIndex;
  const BlogCommentView({super.key, required this.blogIndex});

  @override
  State<StatefulWidget> createState() => _BlogCommentView();
}

class _BlogCommentView extends State<BlogCommentView> {
  final _isTakeMorning = false.obs;
  final _isTakeDinner = false.obs;
  final _isTakePatch = false.obs;
  final _isAntiAnalgesic = false.obs;
  final _isNarcoticAnalgesic = false.obs;
  final _isStimulusCharge = false.obs;

  final _swellingController = SwellingController();
  final _activeController = StimulatorController();
  final _sleepController = StimulatorController();
  final _commentTextController = TextEditingController();

  late CommentProvider _provider;
  late CommentSwellDropdownButton _swellDropdownButton;
  late CommentStimulatorDropdownButton _activeDropDownButton;
  late CommentStimulatorDropdownButton _sleepDrowWondButton;

  bool _isHaveData = false;

  @override
  void initState() {
    _provider = CommentProvider();
    _swellDropdownButton =
        CommentSwellDropdownButton(controller: _swellingController);
    _activeDropDownButton =
        CommentStimulatorDropdownButton(controller: _activeController);
    _sleepDrowWondButton =
        CommentStimulatorDropdownButton(controller: _sleepController);
    super.initState();

    _searchCommentInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text(
          '추가 정보 입력',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        trailing: CommentUpdateButton(onPressed: () {
          _isHaveData ? _updateComment() : _saveComment();
        }),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _makeTakeMedicine(),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 12.0, 5.0, 0.0),
                child: TextField(
                  controller: _commentTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _makeSwellingInfo(),
              _makeStimulusInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _makeTakeMedicine() {
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

  Widget _makeSwellingInfo() {
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
            child: _swellDropdownButton,
          ),
        ],
      ),
    );
  }

  Widget _makeStimulusInfo() {
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
                  child: _activeDropDownButton,
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
                  child: _sleepDrowWondButton,
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

  Future<void> _searchCommentInfor() async {
    EasyLoading.show(status: 'Searching Comment...');

    CommentInfo? comment = await _provider.searchComment(widget.blogIndex);
    if (comment != null) {
      _isHaveData = true;
      _isTakeMorning.value = comment.takeMorning;
      _isTakeDinner.value = comment.takeEvening;
      _isTakePatch.value = comment.usePath;
      _isAntiAnalgesic.value = comment.takeAnalogesic;
      _isNarcoticAnalgesic.value = comment.takeNarcotic;
      _commentTextController.text = comment.comment;
      _swellingController.value = _swellDropdownButton.list[comment.swellingLv];
      _activeController.value = _activeDropDownButton.list[comment.activeMode];
      _sleepController.value = _sleepDrowWondButton.list[comment.sleepMode];
      _isStimulusCharge.value = comment.charging ? true : false;
    } else {
      _isHaveData = false;
    }

    EasyLoading.dismiss();
  }

  Future<void> _updateComment() async {
    EasyLoading.show(status: "Updating Comment...");

    Map<String, dynamic> params = {
      'crawlingIdx': widget.blogIndex,
      'takeMorning': _isTakeMorning.value ? 1 : 0,
      'takeEvening': _isTakeDinner.value ? 1 : 0,
      'antiAnalgesic': _isAntiAnalgesic.value ? 1 : 0,
      'narcoticAnalgesic': _isNarcoticAnalgesic.value ? 1 : 0,
      'usePath': _isTakePatch.value ? 1 : 0,
      'comment': _commentTextController.text,
      'swelling': _swellDropdownButton.list.indexOf(_swellingController.value),
      'activeMode': _activeDropDownButton.list.indexOf(_activeController.value),
      'sleepMode': _sleepDrowWondButton.list.indexOf(_sleepController.value),
      'chargingStimulus': _isStimulusCharge.value ? 1 : 0,
    };

    var message = await _provider.updateComment(jsonEncode(params));
    Fluttertoast.showToast(msg: message);

    EasyLoading.dismiss();
  }

  Future<void> _saveComment() async {
    EasyLoading.show(status: "Saving Comment...");

    Map<String, dynamic> params = {
      'crawlingIdx': widget.blogIndex,
      'takeMorning': _isTakeMorning.value ? 1 : 0,
      'takeEvening': _isTakeDinner.value ? 1 : 0,
      'antiAnalgesic': _isAntiAnalgesic.value ? 1 : 0,
      'narcoticAnalgesic': _isNarcoticAnalgesic.value ? 1 : 0,
      'usePath': _isTakePatch.value ? 1 : 0,
      'comment': _commentTextController.text,
      'swelling': _swellDropdownButton.list.indexOf(_swellingController.value),
      'activeMode': _activeDropDownButton.list.indexOf(_activeController.value),
      'sleepMode': _sleepDrowWondButton.list.indexOf(_sleepController.value),
      'chargingStimulus': _isStimulusCharge.value ? 1 : 0,
    };

    var message = await _provider.saveComment(jsonEncode(params));
    Fluttertoast.showToast(msg: message);

    EasyLoading.dismiss();
  }
}
