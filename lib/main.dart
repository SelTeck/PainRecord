import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pain_record/commmon/hyphen_text_input_formatter.dart';
import 'package:pain_record/model/result.dart';
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
  final _isAutoLogin = false.obs;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  late AuthProvider _authProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _initSharedPreferences();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 최대한 넓게
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  // autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please your Phone Number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: '010-0000-0000',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(13),
                    FilteringTextInputFormatter.digitsOnly,
                    HyphenTextInputFormatter(),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => CheckboxListTile(
                          value: _isAutoLogin.value,
                          contentPadding:
                              EdgeInsets.zero, // Left Padding remove
                          onChanged: (bool? value) {
                            _isAutoLogin.value = value!;
                          },
                          title: const Text('자동 로그인'),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          '로그인',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _initSharedPreferences() async {
    final prefs = await _authProvider.prefs;
    String? value = prefs.getString("AUTO_LOGIN");
    _isAutoLogin.value = (value == null || value.isEmpty) ? false : true;

    if (value != null && value.isNotEmpty) {
      _controller.text = value;
      _loginUser();
    }
  }

  _saveSharedPreferences() async {
    final prefs = await _authProvider.prefs;
    prefs.setString("AUTO_LOGIN", _controller.text);
  }

  _loginUser() async {
    Result? result = await _authProvider.fetchUserCheck(_controller.text);
    if (result == null) {
      _saveSharedPreferences();
      Get.off(
        const TapView(),
      );
    } else {
      Get.defaultDialog(
        title: "알림",
        middleText: result.message,
        onConfirm: () {
          Get.back();
        },
      );
    }
  }
}
