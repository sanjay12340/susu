import 'package:susu/lab_pages/lab_home_page.dart';
import 'package:susu/pages/Login.dart';
import 'package:susu/pages/home_page.dart';
import 'package:susu/pages/splash_page.dart';
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
  box.writeIfNull(StorageConstant.firstTimeUser, true);
  box.writeIfNull(ValueConstant.upi, '');
  runApp(MyApp());
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
      home: screenRoute(),
    );
  }

  Widget screenRoute() {
    if (box.read(StorageConstant.firstTimeUser) != null &&
        box.read(StorageConstant.firstTimeUser)) {
      return const SplashPage();
    }

    return (box.read(StorageConstant.isLoggedIn) == null ||
            !box.read(StorageConstant.isLoggedIn))
        ? LoginPage()
        : (box.read(StorageConstant.lab) != null &&
                box.read(StorageConstant.lab))
            ? LabHomePage()
            : HomePage();
  }
}
