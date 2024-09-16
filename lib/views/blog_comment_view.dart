import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pain_record/model/commentinfo.dart';
import 'package:pain_record/provider/comment_provider.dart';
import 'package:pain_record/widgets/blog_comment/comment_button_update.dart';
import 'package:pain_record/widgets/blog_comment/comment_widget_medicine_infor.dart';
import 'package:pain_record/widgets/blog_comment/comment_widget_stimulus_infor.dart';
import 'package:pain_record/widgets/blog_comment/comment_widget_swelling_infor.dart';

class BlogCommentView extends StatefulWidget {
  final blogIndex;
  const BlogCommentView({super.key, required this.blogIndex});

  @override
  State<StatefulWidget> createState() => _BlogCommentView();
}

class _BlogCommentView extends State<BlogCommentView> {
  final _commentTextController = TextEditingController();

  late CommentProvider _provider;
  late CommentWidgetMedicineInfor _medicineInforBox;
  late CommentWidgetSwellingInfor _swellingInforBox;
  late CommentWidgetStimulusInfor _stimulusInforBox;

  bool _isHaveData = false;

  @override
  void initState() {
    _provider = CommentProvider();
    _medicineInforBox = CommentWidgetMedicineInfor();
    _swellingInforBox = CommentWidgetSwellingInfor();
    _stimulusInforBox = CommentWidgetStimulusInfor();
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
        trailing: CommentButtonUpdate(onPressed: () {
          Map<String, dynamic> params = {
            'crawlingIdx': widget.blogIndex,
            'takeMorning': _medicineInforBox.isTakeMorning ? 1 : 0,
            'takeEvening': _medicineInforBox.isTakeDinner ? 1 : 0,
            'antiAnalgesic': _medicineInforBox.isAntiAnalgesic ? 1 : 0,
            'narcoticAnalgesic': _medicineInforBox.isNarcoticAnalgesic ? 1 : 0,
            'usePath': _medicineInforBox.isTakePatch ? 1 : 0,
            'comment': _commentTextController.text,
            'swelling': _swellingInforBox.value,
            'activeMode': _stimulusInforBox.activeValue,
            'sleepMode': _stimulusInforBox.sleepValue,
            'chargingStimulus': _stimulusInforBox.isStimulusCharge ? 1 : 0,
          };
          _isHaveData
              ? _updateComment(jsonEncode(params))
              : _saveComment(jsonEncode(params));
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _medicineInforBox,
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 12.0, 5.0, 0.0),
              child: TextField(
                controller: _commentTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            _swellingInforBox,
            _stimulusInforBox,
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
      _medicineInforBox.isTakeMorning = comment.takeMorning;
      _medicineInforBox.isTakeDinner = comment.takeEvening;
      _medicineInforBox.isTakePatch = comment.usePath;
      _medicineInforBox.isAntiAnalgesic = comment.takeAnalogesic;
      _medicineInforBox.isNarcoticAnalgesic = comment.takeNarcotic;
      _commentTextController.text = comment.comment;
      _swellingInforBox.value = comment.swellingLv;
      _stimulusInforBox.activeValue = comment.activeMode;
      _stimulusInforBox.sleepValue = comment.sleepMode;
      _stimulusInforBox.isStimulusCharge = comment.charging ? true : false;
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
