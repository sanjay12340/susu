import 'dart:convert';

import 'dart:math';

import 'package:susu/pages/sign_up_final.dart';
import 'package:susu/pages/sing_up_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'forget_password_final.dart';

class VerifyEmailPage extends StatefulWidget {
  VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  final RemoteGameResultService logincheck = RemoteGameResultService();

  final _formKey = GlobalKey<FormState>();
  var _waiting = false.obs;

  //  var _sendAgain = false.obs;
  var _showOTPbox = false.obs;
  var _nextOTP = false.obs;
  int random = 0;
  var _mobileNode = FocusNode();
  var _verigyOTP = FocusNode();
  int _count = 0;
  @override
  void initState() {
    super.initState();
    _mobileNode.addListener(() {
      setState(() {});
    });
    _verigyOTP.addListener(() {
      setState(() {});
    });
  }

  setOTP(String phone, int random) async {
    _waiting.value = true;
    String data = await GenralApiCallService().setOTP(phone, random);
    var d = jsonDecode(data);
    if (d['Status'] == "Success") {
      _waiting.value = false;
      _showOTPbox.value = true;
      _nextOTP.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              "Let's Start",
              style: TextStyle(
                  color: myBlack.withOpacity(.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            Text(
              "Create new account",
              style: TextStyle(
                  color: myBlack.withOpacity(.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Spacer(
              flex: 12,
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(color: Colors.white),
                child: Obx(
                  () => Column(
                    children: [
                      (_showOTPbox.value)
                          ? TextFormField(
                              focusNode: _verigyOTP,
                              cursorColor: myAccentColor,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: myAccentColor),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.sms,
                                    color: _verigyOTP.hasFocus
                                        ? myAccentColor
                                        : Colors.grey,
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(7),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Enter OTP",
                                  labelText: "OTP",
                                  labelStyle: TextStyle(
                                    color: _verigyOTP.hasFocus
                                        ? myAccentColor
                                        : Colors.grey,
                                  )),
                              controller: _otp,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Filed not Empity";
                                } else if (val != random.toString()) {
                                  return "Invalid OTP";
                                }
                                return null;
                              },
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  focusNode: _mobileNode,
                                  cursorColor: myAccentColor,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: myAccentColor),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.sms,
                                      color: _mobileNode.hasFocus
                                          ? myAccentColor
                                          : Colors.grey,
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(7),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Email Id",
                                    labelText: "Email Id",
                                    labelStyle: TextStyle(
                                        color: _mobileNode.hasFocus
                                            ? myPrimaryColor
                                            : Colors.grey),
                                  ),
                                  controller: _email,
                                  validator: (val) {
                                    if (val != null && val.isEmail) {
                                      return null;
                                    }
                                    return "Provide Valid Email";
                                  },
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      (_showOTPbox.value)
                          ? Container(
                              width: size.longestSide,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: myPrimaryColor),
                              child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_otp.text == random.toString()) {
                                        Get.to(
                                          () => SignUPFinalPage(
                                            email: _email.text,
                                          ),
                                        );
                                      } else {
                                        print("not validated");
                                      }
                                    } else {
                                      _count++;
                                      if (_count == 2) {
                                        Get.back();
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Verify OTP",
                                    style: TextStyle(color: myWhite),
                                  )),
                            )
                          : Container(
                              width: size.longestSide,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: myPrimaryColor),
                              child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _waiting.value = true;
                                      random = Random().nextInt(9999) + 1000;

                                      print("Send");
                                      DashboardService.verifyEmail(
                                              _email.text, random.toString())
                                          .then((value) {
                                        _waiting.value = false;
                                        if (value != null) {
                                          if (value['status']) {
                                            _showOTPbox.value = true;
                                          } else {
                                            Get.defaultDialog(
                                                title: "Alert",
                                                middleText: value['msg'] ?? "");
                                          }
                                        } else {
                                          Get.defaultDialog(
                                              title: "Alert",
                                              middleText:
                                                  "Something went wrong");
                                        }
                                      });
                                    }
                                  },
                                  child: (_waiting.value)
                                      ? Container(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          "Send OTP",
                                          style: TextStyle(color: myWhite),
                                        )),
                            ),
                      (_showOTPbox.value)
                          ? Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: myPrimaryColorDark,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: TextButton(
                                        onPressed: () {
                                          random =
                                              Random().nextInt(9999) + 1000;
                                          DashboardService.verifyEmail(
                                                  _email.text,
                                                  random.toString())
                                              .then((value) {
                                            if (value != null) {
                                              if (value['status']) {
                                                _showOTPbox.value = true;
                                              } else {
                                                Get.defaultDialog(
                                                    title: "Alert",
                                                    middleText:
                                                        value['msg'] ?? "");
                                              }
                                            } else {
                                              Get.defaultDialog(
                                                  title: "Alert",
                                                  middleText:
                                                      "Something went wrong");
                                            }
                                            _waiting.value = false;
                                          });
                                        },
                                        child: Text("Resend OTP",
                                            style: TextStyle(color: myWhite))),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: myAccentColorDark,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: TextButton(
                                        onPressed: () {
                                          _showOTPbox.value = false;
                                        },
                                        child: Text("Change Email id",
                                            style: TextStyle(color: myWhite))),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Back To Login",
                      style: TextStyle(
                        color: myPrimaryColor,
                        fontSize: 18,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
