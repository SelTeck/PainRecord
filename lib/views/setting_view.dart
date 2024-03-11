import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pain_record/commmon/commons.dart';
import 'package:pain_record/model/result.dart';
import 'package:pain_record/session/session.dart';
import 'package:pain_record/widgets/setting/enter_stimulus_textfield.dart';
import 'package:pain_record/widgets/setting/setting_future_builder.dart';
import 'package:pain_record/widgets/setting/setting_save_button.dart';

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

  Future<Result>? _future;
  String _selectStimulusMode = '선택';

  void _initialize() {
    _future = null;
  }

  void _clearTextEditingController() {
    _uprightController.text = '';
    _lyingBackController.text = '';
    _lyingLeftController.text = '';
    _lyingRightController.text = '';
    _recliningController.text = '';
    _lyingFrontController.text = '';
  }

  Widget _makeButton() {
    if (_future == null) {
      Commons.logger.i('SelTeck, SettingSaveButton _future = null');
      return SettingSaveButton(
        onPressed: () {
          Commons.logger.i('SelTeck, SettingSaveButton onPressed');
          _future = _uploadStimulusInfor();
          setState(() {});
        },
      );
    }
    Commons.logger.i('SelTeck, SettingSaveButton FutureBuilder');
    return SettingFutureBuilder(
      future: _uploadStimulusInfor(),
      initialzeCallback: _initialize,
      clearTextCallback: _clearTextEditingController,
      makeWidgetCallback: _makeButton,
    );
  }

  Future<Result> _uploadStimulusInfor() async {
    if (_stimulusModes.indexOf(_selectStimulusMode) == 0) {
      Commons.showToast(context: context, message: 'Stimulator 자극 타입을 선택하세요.');
      return Result.message(msg: 'Failed enter this information');
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

    return Result.fromJson(await Session.post(
        url: '${Session.host}/records/input/stimulus/info',
        body: jsonEncode(params)));
  }

  @override
  void initState() {
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
                                      setState(() {
                                        _selectStimulusMode = value!;
                                      });
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
                          _makeButton(),
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
}
