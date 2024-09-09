import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pain_record/model/blogrss.dart';
import 'package:pain_record/provider/auth_provider.dart';
import 'package:pain_record/provider/rss_list_provider.dart';
import 'package:pain_record/views/blog_rss_row_view.dart';
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
    _blogPageList = List.empty(growable: true);
    _token = Provider.of<AuthProvider>(context, listen: false).token;
    _provider = Provider.of<RssListProvider>(context, listen: false);
    _scrollController = ScrollController()..addListener(onScroll);

    _searchRssList();
    super.initState();
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
    // return SafeArea(
    //   child: FutureBuilder<List<BlogRss>>(
    //     future: _provider.fetchBlogRssList(_token),
    //     builder: (context, snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //         // return Text('Press button to start.');
    //         case ConnectionState.waiting:
    //         case ConnectionState.active:
    //         // return Text('Awaiting result...');
    //         case ConnectionState.done:
    //           {
    //             if (snapshot.hasData) {
    //               List<BlogRss> list = snapshot.data!;
    //               _blogPageList.addAll(list);

    //               return RefreshIndicator(
    //                   key: _refreshIndicatorKey,
    //                   child: ListView.separated(
    //                     controller: _scrollController,
    //                     separatorBuilder: (context, index) => const Divider(
    //                       color: Colors.black,
    //                     ),
    //                     itemBuilder: (context, index) {
    //                       return BlogRssRowView(item: _blogPageList[index]);
    //                     },
    //                     itemCount: _blogPageList.length,
    //                   ),
    //                   onRefresh: () async {
    //                     setState(() {
    //                       _provider.page = 0;
    //                       _blogPageList.clear();
    //                     });
    //                   });
    //             } else if (snapshot.hasError) {
    //               throw Error.safeToString(snapshot.error);
    //             }
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //       }
    //     },
    //   ),
    // );
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
      EasyLoading.dismiss();
    });
  }
}
