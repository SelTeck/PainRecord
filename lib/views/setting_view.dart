import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pain_record/provider/auth_provider.dart';
import 'package:pain_record/provider/setting_provider.dart';
import 'package:pain_record/widgets/setting/setting_dropdown_stimulus.dart';
import 'package:pain_record/widgets/setting/setting_textfield_stimulus_infor.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<StatefulWidget> createState() => _SettingView();
}

class _SettingView extends State<SettingView> {
  final _isAutoLogin = false.obs;

  final _uprightController = TextEditingController();
  final _lyingBackController = TextEditingController();
  final _lyingLeftController = TextEditingController();
  final _lyingRightController = TextEditingController();
  final _recliningController = TextEditingController();
  final _lyingFrontController = TextEditingController();

  late AuthProvider _authProvider;
  late SettingProvider _settingProvider;
  late SettingDropdownStimulus _dropdownStimulus;

  int _curStimulusIndex = 0;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _initSharedPreferences();

    _settingProvider = SettingProvider();
    _dropdownStimulus = SettingDropdownStimulus(
      controller: StimulusController(),
      onChanged: () {
        if (_dropdownStimulus.controller.value == '선택') {
          _clearTextEditingController();
        } else {
          if (_dropdownStimulus.controller.value == 'A') {
            _curStimulusIndex = _authProvider.typeA;
          } else if (_dropdownStimulus.controller.value == 'B') {
            _curStimulusIndex = _authProvider.typeB;
          } else {
            // if (_dropdownStimulus.controller.value == 'C') {
            _curStimulusIndex = _authProvider.typeC;
          }
          searchStimulusInfor();
        }
      },
    );

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
                                  child: _dropdownStimulus,
                                ),
                              ),
                            ],
                          ),
                          SettingTextfieldStimulusInfor(
                              content: '서있는 자세',
                              hint: '10.0',
                              controller: _uprightController),
                          SettingTextfieldStimulusInfor(
                              content: '누워있는 자세',
                              hint: '10.0',
                              controller: _lyingBackController),
                          SettingTextfieldStimulusInfor(
                              content: '왼쪽으로 누운 자세',
                              hint: '10.0',
                              controller: _lyingLeftController),
                          SettingTextfieldStimulusInfor(
                              content: '오른쪽으로 누운 자세',
                              hint: '10.0',
                              controller: _lyingRightController),
                          SettingTextfieldStimulusInfor(
                              content: '기대어 있는 자세',
                              hint: '10.0',
                              controller: _recliningController),
                          SettingTextfieldStimulusInfor(
                              content: '엎드린 자세',
                              hint: '10.0',
                              controller: _lyingFrontController),
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                uploadStimulusInfor();
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
                  Obx(
                    () => CheckboxListTile(
                      value: _isAutoLogin.value,
                      contentPadding: EdgeInsets.zero, // Left Padding remove
                      onChanged: (bool? value) {
                        _isAutoLogin.value = value!;
                        _saveSharedPreferences();
                      },
                      title: const Text('자동 로그인'),
                      controlAffinity: ListTileControlAffinity.leading,
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

  _initSharedPreferences() async {
    final prefs = await _authProvider.prefs;
    final value = prefs.getString("AUTO_LOGIN");
    _isAutoLogin.value = (value == null || value.isEmpty) ? false : true;
  }

  _saveSharedPreferences() async {
    final prefs = await _authProvider.prefs;
    prefs.setString(
        "AUTO_LOGIN", _isAutoLogin.value ? _authProvider.account : "");
  }

  void _clearTextEditingController() {
    _curStimulusIndex = 0;
    _uprightController.text = '';
    _lyingBackController.text = '';
    _lyingLeftController.text = '';
    _lyingRightController.text = '';
    _recliningController.text = '';
    _lyingFrontController.text = '';
  }

  Future<void> searchStimulusInfor() async {
    EasyLoading.show(status: 'Searching...');
    final stimulusDetail =
        await _settingProvider.fetchStimulusInfor(_curStimulusIndex);
    if (stimulusDetail == null) {
      Fluttertoast.showToast(msg: 'Failed search Stimulus Information');
    } else {
      _uprightController.text = '${stimulusDetail.upright}';
      _lyingBackController.text = '${stimulusDetail.lyingBack}';
      _lyingLeftController.text = '${stimulusDetail.lyingLeft}';
      _lyingRightController.text = '${stimulusDetail.lyingRight}';
      _recliningController.text = '${stimulusDetail.reclining}';
      _lyingFrontController.text = '${stimulusDetail.lyingFront}';
    }
    EasyLoading.dismiss();
  }

  Future<void> uploadStimulusInfor() async {
    if (_dropdownStimulus.controller.value == '선택') {
      Fluttertoast.showToast(msg: 'Stimulator 자극 타입을 선택하세요.');
    } else {
      EasyLoading.show(status: 'Updating...');
      Map<String, dynamic> params = {
        'type': _dropdownStimulus.controller.value,
        'upright': double.parse(_uprightController.text),
        'lyingFront': double.parse(_lyingFrontController.text),
        'lyingBack': double.parse(_lyingBackController.text),
        'lyingLeft': double.parse(_lyingLeftController.text),
        'lyingRight': double.parse(_lyingRightController.text),
        'reclining': double.parse(_recliningController.text),
      };

      final result =
          await _settingProvider.uploadStimulusInfor(jsonEncode(params));
      if (result.statusCode == 409) {
        if (_curStimulusIndex == 1) {
          // Type A
          _authProvider.typeA = result.number;
        } else if (_curStimulusIndex == 2) {
          // Type B
          _authProvider.typeB = result.number;
        } else if (_curStimulusIndex == 3) {
          // Type C
          _authProvider.typeC = result.number;
        }
        Fluttertoast.showToast(msg: result.message);
      } else {
        Fluttertoast.showToast(msg: 'Failed enter Stimulus Information');
      }
      EasyLoading.dismiss();
    }
  }
}
