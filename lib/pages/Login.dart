import 'dart:convert';

import 'package:susu/lab_pages/lab_home_page.dart';
import 'package:susu/pages/home_page.dart';

import 'package:susu/pages/sign_up_final.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:susu/utils/util.dart';
import 'forget_password_first.dart';

import 'sing_up_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final RemoteGameResultService logincheck = RemoteGameResultService();
  GenralApiCallService genralApiCallService = GenralApiCallService();
  var box = GetStorage();
  var _login = "Login".obs;
  var _show = false.obs;
  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  String? deviceToken = "no";
  @override
  void initState() {
    box.erase();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    super.initState();
    getToken();
    box.write(StorageConstant.firstTimeUser, false);
  }

  getToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
  }

  gameShow() {
    Get.offAll(() => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: myPrimaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/logo.png",
                color: myWhite,
                width: 100,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Welcome to SUSU Labs",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: Get.height * 0.60,
                      width: Get.size.width,
                      decoration: BoxDecoration(
                        color: myWhite,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                      ),
                      child: Column(children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Text("Please enter your login credentials"),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _username,
                                  decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please provide email id";
                                    }
                                    if (value.isEmpty) {
                                      return 'Please enter your email id';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _password,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please provide Password";
                                    }
                                    if (value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shape: const StadiumBorder()),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        DashboardService.loginUser(
                                                _username.text, _password.text)
                                            .then((value) {
                                          if (value == null ||
                                              !value['status']) {
                                            Get.defaultDialog(
                                                title: "Alert",
                                                content: Text(
                                                    "Please check Username or password"));
                                          } else {
                                            if (value['status']) {
                                              Map<String, dynamic> user =
                                                  value['user'];

                                              Util.storeValueOfUser(user);

                                              box.write(StorageConstant.lab,
                                                  user['user_type'] == "lab");
                                              if (user['user_type'] == "lab") {
                                                Get.offAll(LabHomePage());
                                              } else
                                                Get.offAll(HomePage());
                                            }
                                          }
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shape: const StadiumBorder()),
                                    onPressed: () {
                                      Get.to(SignUPFinalPage());
                                      // if (_formKey.currentState!.validate()) {
                                      //   // submit form data to backend
                                      // }
                                    },
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      // submit form data to backend
                                    }
                                  },
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(ForgetPassword());
                                    },
                                    child: const Text(
                                      'Forget Password',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
