// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pain_record/model/commentinfo.dart';
import 'package:pain_record/model/result.dart';
import 'package:pain_record/session/session.dart';

class BlogCommentView extends StatefulWidget {
  final blogIndex;
  const BlogCommentView({Key? key, required this.blogIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlogCommentView();
}

class _BlogCommentView extends State<BlogCommentView> {
  final List<String> swellList = <String>['안 부음', '조금 부음', '제법 부음', '많이 부음'];
  final List<String> stimulatorList = <String>['선택', 'A', 'B', 'C'];

  bool _isHaveData = false;
  bool _isTakeMorning = false,
      _isTakeDinner = false,
      _isTakePatch = false,
      _isAntiAnalgesic = false,
      _isNarcoticAnalgesic = false,
      _isStimulusCharge = false;

  String _activeValue = '선택', _sleepingValue = '선택', _swellValue = '안 부음';

  @override
  void initState() {
    super.initState();
    _showLoading(msg: 'Searching Comment...');
    _searchComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '댓글',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          _makeCommentButton(),
        ],
      ),
      body: Column(
        children: [
          _makeTakeMedicine(),
          _makeSwellingInfo(),
          _makeStimulusInfo(),
        ],
      ),
    );
  }

  Widget _makeCommentButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4.0,
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          _isHaveData ? _updateComment() : _saveComment();
          _showLoading(
              msg: _isHaveData ? "Updating Comment..." : "Saving Comment...");
        },
        icon: const Icon(
          Icons.upload,
          size: 20,
          color: Colors.white,
        ),
        label: const Text(
          '등록',
          style: TextStyle(color: Colors.white, fontSize: 17.0),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
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
            CheckboxListTile(
              value: _isTakeMorning,
              onChanged: (bool? value) {
                setState(() {
                  _isTakeMorning = value!;
                });
              },
              title: const Text('아침 약 복용'),
              subtitle: const Text('울트라셋 한 알 복용'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _isTakeDinner,
              onChanged: (bool? value) {
                setState(() {
                  _isTakeDinner = value!;
                });
              },
              title: const Text('저녁 약 복용'),
              subtitle: const Text('울트라셋 한 알 복용'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _isTakePatch,
              onChanged: (bool? value) {
                setState(() {
                  _isTakePatch = value!;
                });
              },
              title: const Text('뉴도탑 패치 사용'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _isAntiAnalgesic,
              onChanged: (bool? value) {
                setState(() {
                  _isAntiAnalgesic = value!;
                });
              },
              title: const Text('소염진통제 복용'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _isNarcoticAnalgesic,
              onChanged: (bool? value) {
                setState(() {
                  _isNarcoticAnalgesic = value!;
                });
              },
              title: const Text('마약성 진통제 복용'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeSwellingInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(4.0, 20.0, 4.0, 4.0),
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
            child: DropdownButton(
              isExpanded: true,
              value: _swellValue,
              items: swellList.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _swellValue = value!;
                });
              },
            ),
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
                  child: DropdownButton(
                    isExpanded: true,
                    value: _activeValue,
                    items: stimulatorList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _activeValue = value!;
                      });
                    },
                  ),
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
                  child: DropdownButton(
                    isExpanded: true,
                    value: _sleepingValue,
                    items: stimulatorList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sleepingValue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              value: _isStimulusCharge,
              onChanged: (bool? value) {
                setState(() {
                  _isStimulusCharge = value!;
                });
              },
              title: const Text('척수신경 자극기 충전'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            // if (_future != null)
            //   BlogCommentBuilder(
            //     future: _future!,
            //     initialzeCallback: _initialize,
            //   ),
          ],
        ),
      ),
    );
  }

  void _searchComment() async {
    final response = await Session.get(
        url: '${Session.host}/records/data/daily/comment/${widget.blogIndex}');

    if (response.statusCode == 200) {
      final comment = CommentInfo.fromJson(jsonDecode(response.body));
      _isTakeMorning = comment.takeMorning;
      _isTakeDinner = comment.takeEvening;
      _isTakePatch = comment.usePath;
      _isAntiAnalgesic = comment.takeAnalogesic;
      _isNarcoticAnalgesic = comment.takeNarcotic;
      _swellValue = swellList[comment.swellingLv];
      _activeValue = stimulatorList[comment.activeMode];
      _sleepingValue = stimulatorList[comment.sleepMode];
      _isStimulusCharge = comment.charging ? true : false;
      _isHaveData = true;
    } else if (response.statusCode < 200 || response.statusCode > 400) {
      _isHaveData = false;
    }

    _hideLoading();
    setState(() {});
  }

  void _updateComment() async {
    Map<String, dynamic> params = {
      'crawlingIdx': widget.blogIndex,
      'takeMorning': _isTakeMorning ? 1 : 0,
      'takeEvening': _isTakeDinner ? 1 : 0,
      'antiAnalgesic': _isAntiAnalgesic ? 1 : 0,
      'narcoticAnalgesic': _isNarcoticAnalgesic ? 1 : 0,
      'usePath': _isTakePatch ? 1 : 0,
      'swelling': swellList.indexOf(_swellValue),
      'activeMode': stimulatorList.indexOf(_activeValue),
      'sleepMode': stimulatorList.indexOf(_sleepingValue),
      'chargingStimulus': _isStimulusCharge ? 1 : 0,
      'comment': ''
    };

    final response = await Session.put(
        url: '${Session.host}/records/data/update/daily',
        body: jsonEncode(params));

    // if (response.statusCode == 200) {
    // } else if (response.statusCode < 200 || response.statusCode > 400) {
    //   final result = Result.fromJson(jsonDecode(response.body));
    //   Fluttertoast.showToast(msg: result.message);
    // }

    final result = Result.fromJson(jsonDecode(response.body));
    Fluttertoast.showToast(msg: result.message);
    _hideLoading();

    // setState(() {
    // });
  }

  void _saveComment() async {
    Map<String, dynamic> params = {
      'crawlingIdx': widget.blogIndex,
      'takeMorning': _isTakeMorning ? 1 : 0,
      'takeEvening': _isTakeDinner ? 1 : 0,
      'antiAnalgesic': _isAntiAnalgesic ? 1 : 0,
      'narcoticAnalgesic': _isNarcoticAnalgesic ? 1 : 0,
      'usePath': _isTakePatch ? 1 : 0,
      'swelling': swellList.indexOf(_swellValue),
      'activeMode': stimulatorList.indexOf(_activeValue),
      'sleepMode': stimulatorList.indexOf(_sleepingValue),
      'chargingStimulus': _isStimulusCharge ? 1 : 0,
      'comment': ''
    };

    final response = await Session.post(
        url: '${Session.host}/records/data/input/daily',
        body: jsonEncode(params));

    final result = Result.fromJson(jsonDecode(response.body));
    Fluttertoast.showToast(msg: result.message);
  }

  void _showLoading({String? msg}) async {
    await EasyLoading.show(status: msg);
  }

  void _hideLoading() async {
    await EasyLoading.dismiss();
  }
}
