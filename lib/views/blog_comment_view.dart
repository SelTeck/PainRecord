import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pain_record/model/commentinfo.dart';
import 'package:pain_record/provider/comment_provider.dart';
import 'package:pain_record/widgets/blog_comment/comment_medicine_input.dart';
import 'package:pain_record/widgets/blog_comment/comment_stimulator_dropdown_button.dart';
import 'package:pain_record/widgets/blog_comment/comment_swell_dropdown_button.dart';
import 'package:pain_record/widgets/blog_comment/comment_update_button.dart';

class BlogCommentView extends StatefulWidget {
  final blogIndex;
  const BlogCommentView({super.key, required this.blogIndex});

  @override
  State<StatefulWidget> createState() => _BlogCommentView();
}

class _BlogCommentView extends State<BlogCommentView> {
  final _isStimulusCharge = false.obs;

  final _swellingController = SwellingController();
  final _activeController = StimulatorController();
  final _sleepController = StimulatorController();
  final _commentTextController = TextEditingController();

  late CommentProvider _provider;
  late CommentSwellDropdownButton _swellDropdownButton;
  late CommentStimulatorDropdownButton _activeDropDownButton;
  late CommentStimulatorDropdownButton _sleepDrowWondButton;
  late CommentMedicineInput _medicineInputBox;

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

    _medicineInputBox = CommentMedicineInput();
    super.initState();

    _searchCommentInfor();
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
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
          Map<String, dynamic> params = {
            'crawlingIdx': widget.blogIndex,
            'takeMorning': _medicineInputBox.isTakeMorning ? 1 : 0,
            'takeEvening': _medicineInputBox.isTakeDinner ? 1 : 0,
            'antiAnalgesic': _medicineInputBox.isAntiAnalgesic ? 1 : 0,
            'narcoticAnalgesic': _medicineInputBox.isNarcoticAnalgesic ? 1 : 0,
            'usePath': _medicineInputBox.isTakePatch ? 1 : 0,
            'comment': _commentTextController.text,
            'swelling':
                _swellDropdownButton.list.indexOf(_swellingController.value),
            'activeMode':
                _activeDropDownButton.list.indexOf(_activeController.value),
            'sleepMode':
                _sleepDrowWondButton.list.indexOf(_sleepController.value),
            'chargingStimulus': _isStimulusCharge.value ? 1 : 0,
          };
          _isHaveData
              ? _updateComment(jsonEncode(params))
              : _saveComment(jsonEncode(params));
        }),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _medicineInputBox,
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
      _medicineInputBox.isTakeMorning = comment.takeMorning;
      _medicineInputBox.isTakeDinner = comment.takeEvening;
      _medicineInputBox.isTakePatch = comment.usePath;
      _medicineInputBox.isAntiAnalgesic = comment.takeAnalogesic;
      _medicineInputBox.isNarcoticAnalgesic = comment.takeNarcotic;
      _commentTextController.text = comment.comment.toString();
      _swellingController.value = _swellDropdownButton.list[comment.swellingLv];
      _activeController.value = _activeDropDownButton.list[comment.activeMode];
      _sleepController.value = _sleepDrowWondButton.list[comment.sleepMode];
      _isStimulusCharge.value = comment.charging ? true : false;
    } else {
      _isHaveData = false;
    }

    EasyLoading.dismiss();
  }

  Future<void> _updateComment(String params) async {
    EasyLoading.show(status: "Updating Comment...");

    var message = await _provider.updateComment(params);
    Fluttertoast.showToast(msg: message);

    EasyLoading.dismiss();
  }

  Future<void> _saveComment(String params) async {
    EasyLoading.show(status: "Saving Comment...");

    var message = await _provider.saveComment(params);
    Fluttertoast.showToast(msg: message);

    EasyLoading.dismiss();
  }
}
