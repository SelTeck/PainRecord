import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pain_record/commmon/define.dart';
import 'package:pain_record/model/blogrss.dart';
import 'package:pain_record/session/session.dart';
import 'package:pain_record/views/blog_rss_row_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RssListView extends StatefulWidget {
  const RssListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RssListView();
}

class _RssListView extends State<RssListView> {
  var _page = 0;

  final _refreshIndicatorKey = GlobalKey();
  final _memoizer = AsyncMemoizer<List<BlogRss>>();

  late List<BlogRss> _blogPageList;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _page = 0;
    _blogPageList = List.empty(growable: true);
    _scrollController = ScrollController()..addListener(onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<BlogRss>>(
        future: _fetchBlogRssList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // return Text('Press button to start.');
            case ConnectionState.waiting:
            case ConnectionState.active:
            // return Text('Awaiting result...');
            case ConnectionState.done:
              {
                if (snapshot.hasData) {
                  List<BlogRss> list = snapshot.data!;
                  if (_blogPageList.isEmpty) {
                    _blogPageList.addAll(list);
                  }
                  return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      child: ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                        ),
                        itemBuilder: (context, index) {
                          return BlogRssRowView(item: _blogPageList[index]);
                        },
                        itemCount: _blogPageList.length,
                      ),
                      onRefresh: () async {
                        setState(() {
                          _page = 0;
                          _blogPageList.clear();
                        });
                      });
                } else if (snapshot.hasError) {
                  throw Error.safeToString(snapshot.error);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        },
      ),
    );
  }

  Future<List<BlogRss>> _fetchBlogRssList() async {
    return _memoizer.runOnce(() async {
      _page += 1;

      print('SelTeck ... called _getBlogRssInfo. page = $_page');
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString(Defines.TOKEN)!;
      Session.headers['Authorization'] = 'Bearer $token';
      // Session.cookies['Authorization'] = 'Bearer $token';

      final response = await Session.get(
          url: '${Session.host}/records/list/$_page/${Defines.VIEW_COUNT}');

      if (response.statusCode < 200 || response.statusCode > 400) {
        return [];
      }
      List list = jsonDecode(response.body) as List;
      return list.map((e) => BlogRss.fromJson(e)).toList();
    });
  }

  void _loadMoreBlogRss() async {
    _page += 1;

    print('SelTeck ... called _getBlogRssInfo. page = $_page');
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString(Defines.TOKEN)!;
    Session.headers['Authorization'] = 'Bearer $token';
    // Session.cookies['Authorization'] = 'Bearer $token';

    final response = await Session.get(
        url: '${Session.host}/records/list/$_page/${Defines.VIEW_COUNT}');

    if (response.statusCode < 200 || response.statusCode > 400) {
      return null;
    }

    List list = jsonDecode(response.body) as List;
    // var result = list.map((e) => BlogRss.fromJson(e)).toList();
    setState(() {
      _blogPageList.addAll(list.map((e) => BlogRss.fromJson(e)).toList());
    });
  }

  void onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // dataFuture = loadmore(items.length, pageSize);
      print('SelTeck ... called onScroll more Add item');
      _loadMoreBlogRss();
    }
  }
}
