import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'package:mobile_number/mobile_number.dart';
import 'package:pain_record/commmon/commons.dart';
import 'package:pain_record/commmon/define.dart';
import 'package:pain_record/model/result.dart';
import 'package:pain_record/model/stimulusInfor.dart';
import 'package:pain_record/views/tap_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pain_record/model/userInfor.dart';
import 'package:pain_record/session/session.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  runApp(const MyApp());
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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenView();
}

class _HomeScreenView extends State<HomeScreen> {
  late SharedPreferences pref;

  String _mobileNumber = '010-8954-6897';

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      // _simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {});
  }

  Future<UserInfor?> _fetchPhoneNumberCheck(String mobileNumber) async {
    Map<String, String> body = {'user': mobileNumber};

    final response = await Session.post(
        url: '${Session.host}/auth/users', body: jsonEncode(body));

    if (response.statusCode < 200 || response.statusCode > 400) {
      final result = Result.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: result.message);
      return null;
    }

    return UserInfor.fromJson(json.decode(response.body));
  }

  Future<StimulusInfor?> _fetchUserCheck(String mobileNumber) async {
    pref = await SharedPreferences.getInstance();
    final userInfor = await _fetchPhoneNumberCheck(mobileNumber);

    if (userInfor != null) {
      pref.setString(Defines.TOKEN, userInfor.token);

      final response = await Session.get(url: '${Session.host}/auth/stimulus');
      if (response.statusCode < 200 || response.statusCode > 400) {
        return null;
      }

      return StimulusInfor.fromJson(json.decode(response.body));
    }

    return null;
  }
  // Future<UserInfor> _userLogin(String mobileNumber) async {
  //   pref = await SharedPreferences.getInstance();

  //   const String url = '${Session.host}/auth/users';
  //   Map<String, String> body = {'user': mobileNumber};

  //   return UserInfor.fromJson(
  //       await Session.post(url: url, body: jsonEncode(body)));
  // }

  @override
  void initState() {
    super.initState();

    // MobileNumber.listenPhonePermission((isPermissionGranted) {
    //   if (isPermissionGranted) {
    //     initMobileNumberState();
    //     setState(() {});
    //   } else {}
    // });
    _fetchPhoneNumberCheck(_mobileNumber);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
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
              future: _fetchUserCheck(_mobileNumber),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  for (var element in snapshot.data!.json) {
                    if (element['type'] == 'A') {
                      pref.setInt(Defines.TYPE_A, element['index']);
                    } else if (element['type'] == 'B') {
                      pref.setInt(Defines.TYPE_B, element['index']);
                    } else {
                      //if (element['type'] == 'C') {
                      pref.setInt(Defines.TYPE_C, element['index']);
                    }
                  }
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const TapView()));
                  });
                } else if (snapshot.hasError) {
                  Commons.logger.e('ERROR!!! ${snapshot.error}');
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

  Future<bool> _showExitPopup() async {
    return await showDialog(
          //show confirm dialogue the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
