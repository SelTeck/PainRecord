import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pain_record/commmon/commons.dart';
import 'package:pain_record/provider/auth_provider.dart';
import 'package:pain_record/views/tap_view.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
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
      home: const HomeScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenLayout();
}

class _HomeScreenLayout extends State<HomeScreen> {
  final _mobileNumber = '010-8954-6897';

  late AuthProvider _authProvider;

  _HomeScreenLayout() {}

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loginUser();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/flutter-logo_drzj7u.png'),
            ),
          ),
        ),
      ),
    );
  }

  _loginUser() async {
    try {
      if (await _authProvider.fetchUserCheck(_mobileNumber) == true) {
        // Future.delayed(Duration.zero, () {
        Get.off(
          const TapView(),
        );
        // });
      }
    } catch (e) {
      print('Error: $e');
      // TODO 로그인 실패 로직 추가
    }
  }
}
