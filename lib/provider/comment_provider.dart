import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pain_record/session/session.dart';
import 'package:pain_record/model/result.dart';
import 'package:pain_record/model/commentinfo.dart';

class CommentProvider with ChangeNotifier {
  // final AsyncMemoizer _morizer = AsyncMemoizer();

  Future<CommentInfo?> searchComment(int blogIndex) async {
    final response = await Session.get(
        url: '${Session.host}/records/data/daily/comment/$blogIndex');

    if (response.statusCode == 200) {
      return CommentInfo.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<String> updateComment(String params) async {
    final response = await Session.put(
        url: '${Session.host}/records/data/update/daily', body: params);

    return Result.fromJson(jsonDecode(response.body)).message;
  }

  Future<String> saveComment(String params) async {
    final response = await Session.post(
        url: '${Session.host}/records/data/input/daily', body: params);

    return Result.fromJson(jsonDecode(response.body)).message;
  }
}
