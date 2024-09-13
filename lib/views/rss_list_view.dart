import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pain_record/model/blogrss.dart';
import 'package:pain_record/provider/auth_provider.dart';
import 'package:pain_record/provider/rss_list_provider.dart';
import 'package:pain_record/widgets/blog_rss_row_view.dart';
import 'package:provider/provider.dart';

class RssListView extends StatefulWidget {
  const RssListView({super.key});

  @override
  State<StatefulWidget> createState() => _RssListView();
}

class _RssListView extends State<RssListView> {
  late String _token;
  late RssListProvider _provider;
  late List<BlogRss> _blogPageList;
  late ScrollController _scrollController;

  final _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    _provider = RssListProvider();
    _blogPageList = List.empty(growable: true);
    _token = Provider.of<AuthProvider>(context, listen: false).token;
    _scrollController = ScrollController()..addListener(onScroll);

    super.initState();
    _provider.page = 0;
    _searchRssList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: RefreshIndicator(
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
            _provider.page = 0;
            _blogPageList.clear();
          });
        },
      ),
    );
  }

  void onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      log('SelTeck ... called onScroll more Add item');
      _searchRssList();
    }
  }

  Future<void> _searchRssList() async {
    EasyLoading.show(status: "Loading...");

    List<BlogRss> list = await _provider.fetchBlogRssList(_token);
    setState(() {
      _blogPageList.addAll(list);
    });
    EasyLoading.dismiss();
  }
}
