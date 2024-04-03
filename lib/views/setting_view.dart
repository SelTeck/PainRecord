import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pain_record/model/result.dart';
import 'package:pain_record/model/stimulusDetail.dart';
import 'package:pain_record/model/stimulusInput.dart';
import 'package:pain_record/session/session.dart';
import 'package:pain_record/widgets/setting/enter_stimulus_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingView();
}

class _SettingView extends State<SettingView> {
  final List<String> _stimulusModes = ['선택', 'A', 'B', 'C'];

  final _uprightController = TextEditingController();
  final _lyingBackController = TextEditingController();
  final _lyingLeftController = TextEditingController();
  final _lyingRightController = TextEditingController();
  final _recliningController = TextEditingController();
  final _lyingFrontController = TextEditingController();

  late String _selectStimulusMode;
  late SharedPreferences pref;

  @override
  void initState() {
    initData();
    _selectStimulusMode = '선택';
    super.initState();
  }

  @override
  void dispose() {
    _uprightController.dispose();
    _lyingBackController.dispose();
    _lyingLeftController.dispose();
    _lyingRightController.dispose();
    _recliningController.dispose();
    _lyingFrontController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '척수신경 자극기 설정',
                        labelStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 2.0, 8.0, 2.0),
                                  margin: const EdgeInsets.only(left: 2.0),
                                  child: const Text(
                                    '자극 모드',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 2.0, 8.0, 2.0),
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: _selectStimulusMode,
                                    items: _stimulusModes.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      _selectStimulusMode = value!;
                                      if (_stimulusModes.indexOf(value) == 0) {
                                        setState(() {
                                          _clearTextEditingController();
                                        });
                                      } else {
                                        _showLoading(
                                            msg:
                                                "Search Stimulus Information...");
                                        setState(() {});
                                        _getStimulusInfor();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          EnterStimulusTextfield(
                              content: '서있는 자세',
                              hint: '10.0',
                              controller: _uprightController),
                          EnterStimulusTextfield(
                              content: '누워있는 자세',
                              hint: '10.0',
                              controller: _lyingBackController),
                          EnterStimulusTextfield(
                              content: '왼쪽으로 누운 자세',
                              hint: '10.0',
                              controller: _lyingLeftController),
                          EnterStimulusTextfield(
                              content: '오른쪽으로 누운 자세',
                              hint: '10.0',
                              controller: _lyingRightController),
                          EnterStimulusTextfield(
                              content: '기대어 있는 자세',
                              hint: '10.0',
                              controller: _recliningController),
                          EnterStimulusTextfield(
                              content: '엎드린 자세',
                              hint: '10.0',
                              controller: _lyingFrontController),
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                _showLoading(msg: "Uploading...");
                                _uploadStimulusInfor();
                                // setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                '저장',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void initData() async {
    pref = await SharedPreferences.getInstance();
  }

  void _clearTextEditingController() {
    _selectStimulusMode = '선택';
    _uprightController.text = '';
    _lyingBackController.text = '';
    _lyingLeftController.text = '';
    _lyingRightController.text = '';
    _recliningController.text = '';
    _lyingFrontController.text = '';
  }

  void _getStimulusInfor() async {
    final type = 'TYPE_$_selectStimulusMode';
    final index = pref.getInt(type);

    final response = await Session.get(
        url: '${Session.host}/records/data/stimulus/detail/$index');

    if (response.statusCode == 200) {
      final detail = StimulusDetail.fromJson(jsonDecode(response.body));
      _uprightController.text = '${detail.upright}';
      _lyingBackController.text = '${detail.lyingBack}';
      _lyingLeftController.text = '${detail.lyingLeft}';
      _lyingRightController.text = '${detail.lyingRight}';
      _recliningController.text = '${detail.reclining}';
      _lyingFrontController.text = '${detail.lyingFront}';
    } else if (response.statusCode < 200 || response.statusCode > 400) {
      final result = Result.fromJson(jsonDecode(response.body));
      Fluttertoast.showToast(msg: result.message);
    }

    _hideLoading();
  }

  void _uploadStimulusInfor() async {
    if (_stimulusModes.indexOf(_selectStimulusMode) == 0) {
      Fluttertoast.showToast(msg: 'Stimulator 자극 타입을 선택하세요.');
      return null;
    }

    Map<String, dynamic> params = {
      'type': _selectStimulusMode,
      'upright': double.parse(_uprightController.text),
      'lyingFront': double.parse(_lyingFrontController.text),
      'lyingBack': double.parse(_lyingBackController.text),
      'lyingLeft': double.parse(_lyingLeftController.text),
      'lyingRight': double.parse(_lyingRightController.text),
      'reclining': double.parse(_recliningController.text),
    };

    final response = await Session.post(
        url: '${Session.host}/records/data/input/stimulus/info',
        body: jsonEncode(params));

    late Result result;
    if (response.statusCode == 200 || response.statusCode == 409) {
      result = StimulusInput.fromJson(jsonDecode(response.body));
      final type = 'TYPE_$_selectStimulusMode';
      pref.setInt(type, (result as StimulusInput).number);
    } else {
      result = Result.fromJson(jsonDecode(response.body));
    }

    _hideLoading();
    Fluttertoast.showToast(msg: result.message);
  }

  void _showLoading({String? msg}) async {
    await EasyLoading.show(status: msg);
  }

  void _hideLoading() async {
    await EasyLoading.dismiss();
  }
}
