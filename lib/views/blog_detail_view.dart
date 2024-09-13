import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pain_record/views/blog_comment_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BlogDetailView extends StatefulWidget {
  final String url;
  final int blogIndex;
  const BlogDetailView({super.key, required this.url, required this.blogIndex});

  @override
  State<StatefulWidget> createState() => _BlogDetailView();
}

class _BlogDetailView extends State<BlogDetailView> {
  final GlobalKey webViewKey = GlobalKey();
  late final WebViewController _controller;

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          _showLoading();
        },
        onPageFinished: (url) {
          _dismissLoading();
        },
      ));
    // #docregion platform_features
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '상세 보기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 4.0,
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(BlogCommentView(blogIndex: widget.blogIndex));
            },
            icon: const Icon(
              Icons.upload,
              size: 20,
              color: Colors.white,
            ),
            label: const Text(
              '댓글',
              style: TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ),
      child: CupertinoPageScaffold(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }

  _showLoading() async {
    await EasyLoading.show(status: 'Loading...');
  }

  _dismissLoading() async {
    await EasyLoading.dismiss();
  }
}
