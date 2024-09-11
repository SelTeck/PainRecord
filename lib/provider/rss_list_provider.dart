import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pain_record/commmon/define.dart';
import 'package:pain_record/model/blogrss.dart';
import 'package:pain_record/session/session.dart';

class RssListProvider with ChangeNotifier {
  var _page = 0;
  // final _memoizer = AsyncMemoizer<List<BlogRss>>();
  set page(int page) => _page = page;

  Future<List<BlogRss>> fetchBlogRssList(String token) async {
    _page += 1;

    print('SelTeck ... called _getBlogRssInfo. page = $_page');
    Session.headers['Authorization'] = 'Bearer $token';

    final response = await Session.get(
        url: '${Session.host}/records/list/$_page/${Defines.VIEW_COUNT}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => BlogRss.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }
}
