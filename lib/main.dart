import 'package:flutter/foundation.dart';
import 'package:susu/pages/Login.dart';
import 'package:susu/pages/home_page.dart';
import 'package:susu/utils/links.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/value_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:get_storage/get_storage.dart';
import 'services/genral_api_call.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  final box = GetStorage();
  box.writeIfNull(StorageConstant.isLoggedIn, false);
  box.writeIfNull('isGameShow', false);
  box.writeIfNull(StorageConstant.live, false);
  box.writeIfNull(ValueConstant.upi, '');
  runApp(MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  var box = GetStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return GetMaterialApp(
      title: appname,
      theme: ThemeData.light().copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: myAccentColor, primary: myPrimaryColorDark),
          buttonTheme: ButtonThemeData(
              buttonColor: myPrimaryColorDark,
              textTheme: ButtonTextTheme.primary)),
      home: (box.read(StorageConstant.isLoggedIn) == null ||
              !box.read(StorageConstant.isLoggedIn))
          ? LoginPage()
          : HomePage(),
    );
  }
}
