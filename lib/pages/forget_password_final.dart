import 'package:susu/pages/Login.dart';
import 'package:susu/pages/home_page_old.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordFinal extends StatefulWidget {
  final String? email;
  ForgetPasswordFinal({Key? key, this.email}) : super(key: key);

  @override
  _ForgetPasswordFinalState createState() => _ForgetPasswordFinalState();
}

class _ForgetPasswordFinalState extends State<ForgetPasswordFinal> {
  final TextEditingController _password = TextEditingController();

  final RemoteGameResultService logincheck = RemoteGameResultService();
  GenralApiCallService genralApiCallService = GenralApiCallService();
  var _login = "Reset Password".obs;
  var _show = false.obs;

  final _formKey = GlobalKey<FormState>();
  RemoteGameResultService createUSer = RemoteGameResultService();

  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: size.height,
          width: size.height,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                "Hurrey,",
                style: TextStyle(
                    color: myBlack, fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Text(
                "Let's Finish up!",
                style: TextStyle(
                    color: myBlack.withOpacity(.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Spacer(
                flex: 6,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        width: Get.size.longestSide,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                        decoration: BoxDecoration(color: myPrimaryColorDark),
                        child: Text("${widget.email}",
                            style: TextStyle(color: myWhite, fontSize: 20)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => TextFormField(
                          focusNode: _focusNodes[1],
                          obscureText: _show.value,
                          controller: _password,
                          decoration: InputDecoration(
                              focusColor: myAccentColor,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myAccentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: _focusNodes[1].hasFocus
                                    ? myAccentColor
                                    : Colors.grey,
                              ),
                              suffix: InkWell(
                                  onTap: () {
                                    _show.value = !_show.value;
                                  },
                                  child: Icon(_show.value
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye_rounded)),
                              border: new OutlineInputBorder(
                                gapPadding: 5,
                                borderRadius: new BorderRadius.circular(7),
                                borderSide: new BorderSide(),
                              ),
                              hintText: "Password",
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  color: _focusNodes[1].hasFocus
                                      ? myAccentColor
                                      : myBlack)),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Filed not Empity";
                            }
                            if (val.length < 6) {
                              return "Password greater then 6";
                            } else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Container(
                          width: size.longestSide,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [myPrimaryColor, myAccentColor])),
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_password.text.length > 5) {
                                    Get.defaultDialog(
                                      title: "Reset Password",
                                      middleText: "Please Wait...",
                                      barrierDismissible: false,
                                    );
                                    DashboardService.updatePassword(
                                            widget.email!, '', _password.text)
                                        .then((value) {
                                      if (value != null) {
                                        if (value['status']) {
                                          Get.back();
                                          Get.defaultDialog(
                                              title: "congratulations",
                                              middleText:
                                                  "Your Password is updated",
                                              barrierDismissible: false,
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.offAll(
                                                          () => LoginPage());
                                                    },
                                                    child: Text("Ok"))
                                              ]);
                                        } else {
                                          Get.back();
                                          Get.defaultDialog(
                                              title: "Opps",
                                              middleText: value['msg'] ??
                                                  "Something went wrong",
                                              barrierDismissible: false,
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.offAll(
                                                          () => LoginPage());
                                                    },
                                                    child: Text("Ok"))
                                              ]);
                                        }
                                      }
                                    });
                                  } else {
                                    Get.back();
                                    Get.defaultDialog(
                                        title: "Sorry",
                                        middleText:
                                            "Password shoud be 5 or more length",
                                        barrierDismissible: false,
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Get.offAll(() => LoginPage());
                                              },
                                              child: Text("Ok"))
                                        ]);
                                  }
                                }
                              },
                              child: Text(
                                _login.value,
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: 15,
              ),
              Container(
                width: size.longestSide,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [myPrimaryColor, myAccentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(color: myWhite),
                    )),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )),
    ));
  }
}
