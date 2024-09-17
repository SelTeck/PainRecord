import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pain_record/model/stimulusDetail.dart';
import 'package:pain_record/model/stimulusInput.dart';
import 'package:pain_record/session/session.dart';

class SettingProvider with ChangeNotifier {
  Future<StimulusDetail?> fetchStimulusInfor(int index) async {
    final response = await Session.get(
        url: '${Session.host}/records/data/stimulus/detail/$index');

    if (response.statusCode == 200) {
      return StimulusDetail.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<StimulusInput> uploadStimulusInfor(String params) async {
    final response = await Session.post(
        url: '${Session.host}/records/data/input/stimulus/info', body: params);
    final result = StimulusInput.fromJson(jsonDecode(response.body));
    result.statusCode = response.statusCode;

    return result;
  }
}
