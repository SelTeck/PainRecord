import 'dart:io';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:pain_record/views/blog_comment_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BlogDetailView extends StatefulWidget {
  final String url;
  final int blogIndex;
  const BlogDetailView({Key? key, required this.url, required this.blogIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlogDetailView();
}

class _BlogDetailView extends State<BlogDetailView> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

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
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
        },
      ));
    // #docregion platform_features
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      blurEffectIntensity: 4,
      progressIndicator: const SpinKitFadingCircle(
        color: Colors.purple,
        size: 50.0,
      ),
      dismissible: false,
      opacity: 0.7,
      color: Colors.black45,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '상세 보기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          BlogCommentView(blogIndex: widget.blogIndex),
                      fullscreenDialog: false,
                    ),
                  );
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
          ],
        ),
        body: SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
