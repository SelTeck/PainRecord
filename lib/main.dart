import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pain_record/provider/main_provider.dart';
import 'package:pain_record/views/tap_view.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MainProvider()),
    // ChangeNotifierProvider(create: (context) => RssListProvider()),
    // ChangeNotifierProvider(create: (context) => CommentProvider()),
    // ChangeNotifierProvider(create: (context) => SettingProvider()),
  ], child: const MyApp()));

  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // textTheme: TextTheme(
        //   //To support the following, you need to use the first initialization method
        //     button: TextStyle(fontSize: 13.sp)
        // ),
      ),
      home: const HomeScreenLayout(),
      builder: EasyLoading.init(),
    );
  }
}

class HomeScreenLayout extends StatelessWidget {
  const HomeScreenLayout({super.key});
  final _mobileNumber = '010-8954-6897';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context, listen: false);
    return CupertinoPageScaffold(
      child: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/flutter-logo_drzj7u.png'),
                ),
              ),
            ),
            FutureBuilder(
              future: provider.fetchUserCheck(_mobileNumber),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    Future.delayed(Duration.zero, () {
                      Get.off(
                        const TapView(),
                      );
                    });
                  }
                } else if (snapshot.hasError) {
                  throw Error.safeToString(snapshot.error);
                }

                return Container(
                  alignment: Alignment.bottomCenter,
                  child: const LinearProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
