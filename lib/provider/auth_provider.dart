import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pain_record/model/result.dart';
import 'package:pain_record/model/stimulusInfor.dart';
import 'package:pain_record/model/userInfor.dart';
import 'package:pain_record/session/session.dart';

class AuthProvider with ChangeNotifier {
  late String _token;
  int _typeA = -1, _typeB = -1, _typeC = -1;

  String get token => _token;
  int get typeA => _typeA;
  int get typeB => _typeB;
  int get typeC => _typeC;

  Future<bool> fetchUserCheck(String mobileNumber) async {
    Result? result;

    EasyLoading.show(status: "Logining...");

    Map<String, String> body = {'user': mobileNumber};

    final userRes = await Session.post(
        url: '${Session.host}/auth/users', body: jsonEncode(body));

    if (userRes.statusCode == 200) {
      result = null;
      _token = UserInfor.fromJson(json.decode(userRes.body)).token;

      final stimulustInforRes =
          await Session.get(url: '${Session.host}/auth/stimulus');
      if (stimulustInforRes.statusCode == 200) {
        final stimulusInfor =
            StimulusInfor.fromJson(json.decode(stimulustInforRes.body));
        for (var element in stimulusInfor.json) {
          if (element['type'] == 'A') {
            _typeA = element['index'];
          } else if (element['type'] == 'B') {
            _typeB = element['index'];
          } else {
            //if (element['type'] == 'C') {
            _typeC = element['index'];
          }
        }
        result = null;
      } else {
        result = Result.fromJson(json.decode(stimulustInforRes.body));
      }
    } else {
      // if (response.statusCode < 200 || response.statusCode > 400) {
      result = Result.fromJson(json.decode(userRes.body));
    }

    EasyLoading.dismiss();
    return result == null ? true : false;
  }
}
