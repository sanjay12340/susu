import 'dart:convert';
import 'dart:developer';

import 'package:date_time_format/date_time_format.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:susu/pages/Login.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/register_user_model.dart';
import '../utils/storage_constant.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';

class SignUPFinalPage extends StatefulWidget {
  SignUPFinalPage({Key? key}) : super(key: key);

  @override
  _SignUPFinalPageState createState() => _SignUPFinalPageState();
}

class _SignUPFinalPageState extends State<SignUPFinalPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final TextEditingController _ref = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final RemoteGameResultService logincheck = RemoteGameResultService();
  String _age = "age";
  String _selectedSex = "select";
  String errorSex = "";
  String errorAge = "";
  String matchPasswordError = "";
  List<DropdownMenuItem<String>> selectSexDropdown = const [
    DropdownMenuItem(
      value: "select",
      child: Text(
        "Select",
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DropdownMenuItem(
      value: "male",
      child: Text(
        "Male",
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DropdownMenuItem(
      value: "female",
      child: Text(
        "Female",
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DropdownMenuItem(
      value: "transgender",
      child: Text(
        "Transgender",
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ];

  var dob = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dob, // Refer step 1
      firstDate: DateTime(1932),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
        _age = "${calculateAge(picked)} years";
        if (calculateAge(picked) < 12) {
          errorAge = "Not Valid age";
        } else {
          errorAge = "";
        }
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    print("Age $age");
    return age;
  }

  var _login = "Register".obs;
  var _show = false.obs;
  var _alreadyUser = false.obs;
  var _alreadyUserPhone = false.obs;
  String? deviceToken = "";
  final _formKey = GlobalKey<FormState>();
  RemoteGameResultService createUSer = RemoteGameResultService();

  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  var box = GetStorage();

  @override
  void initState() {
    super.initState();

    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    getToken();
  }

  getToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
  }

  gameShow() {
    if (box.read(StorageConstant.live)) {
      Get.offAll(() => HomePage());
    }
  }

  bool validateEmail(String email) {
    // Define the regex pattern for an email address
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    // Create a RegExp object from the pattern
    final regExp = RegExp(pattern);

    // Use the RegExp object to match the email string
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: myHeightXLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: myHeightMedium,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Sign Up",
                      style: Get.theme.textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          TextFormFieldWithSizeBox(
                            focusNode: _focusNodes[0],
                            fullNameController: _fullNameController,
                            label: "Full Name",
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 3) {
                                return "Name should by min 3 chart's";
                              }
                              return null;
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 1,
                                      color: errorAge.isEmpty
                                          ? Colors.black54
                                          : Colors.red)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Row(children: [
                                Icon(
                                  Icons.person,
                                  color: errorAge.isEmpty
                                      ? Colors.black54
                                      : Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _age,
                                  style: TextStyle(fontSize: 18),
                                )
                              ]),
                            ),
                          ),
                          errorAge.isEmpty
                              ? SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        errorAge,
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    width: 1,
                                    color: errorSex.isEmpty
                                        ? Colors.black54
                                        : Colors.red)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.venusMars,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  color: Colors.transparent)),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  color: Colors.transparent)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  color: Colors.transparent))),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        _selectedSex = value!;
                                        setState(() {
                                          if (value == "select") {
                                            errorSex = "Please select Gender";
                                          } else {
                                            errorSex = "";
                                          }
                                        });
                                      },
                                      value: _selectedSex,
                                      items: selectSexDropdown
                                          .map((val) => val)
                                          .toList()),
                                ),
                              ],
                            ),
                          ),
                          errorSex.isEmpty
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        errorSex,
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 4,
                          ),
                          TextFormFieldWithSizeBox(
                            focusNode: _focusNodes[3],
                            fullNameController: _heightController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            label: "Height (in cm)",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "height can't Empty ";
                              }
                              return null;
                            },
                          ),
                          TextFormFieldWithSizeBox(
                            focusNode: _focusNodes[4],
                            fullNameController: _weightController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            label: "Weight (in Kg)",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Weight can't Empty ";
                              }
                              return null;
                            },
                            iconData: FontAwesomeIcons.dumbbell,
                          ),
                          TextFormFieldWithSizeBox(
                            focusNode: _focusNodes[5],
                            fullNameController: _emailController,
                            label: "Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email can't Empty ";
                              } else if (value != null) {
                                if (!validateEmail(value)) {
                                  return "Email  is not valid";
                                }
                              }

                              return null;
                            },
                            iconData: Icons.email_rounded,
                          ),
                          TextFormFieldWithSizeBox(
                            focusNode: _focusNodes[6],
                            fullNameController: _passwordController,
                            obscureText: true,
                            label: "Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password can't Empty ";
                              } else if (value.length < 6) {
                                return "password should 6 chart's ";
                              }
                              return null;
                            },
                            iconData: Icons.key_sharp,
                          ),
                          TextFormFieldWithSizeBox(
                            focusNode: _focusNodes[7],
                            obscureText: true,
                            fullNameController: _cPasswordController,
                            label: "Confirm Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password can't Empty ";
                              } else if (value.length < 6) {
                                return "password should 6 chart's ";
                              }
                              return null;
                            },
                            iconData: Icons.key_sharp,
                          ),
                          matchPasswordError.isEmpty
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: myHeightLarge),
                                  child: Text(
                                    matchPasswordError,
                                    style:
                                        TextStyle(color: Colors.red.shade700),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: myHeightLarge),
                            child: Text(
                              "By Logging in  or signing up. you agree to the policy",
                              style: Get.theme.textTheme.bodySmall!,
                            ),
                          ),
                          SizedBox(
                            width: Get.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: myHeightMedium),
                                    shape: const StadiumBorder()),
                                onPressed: () {
                                  if (_age == "age" || dob.year < 12) {
                                    setState(() {
                                      errorAge = "Please Provide age";
                                    });
                                  } else {
                                    setState(() {
                                      errorAge = "";
                                    });
                                  }

                                  if (_selectedSex == "select") {
                                    setState(() {
                                      errorSex = "Please Select Gender";
                                    });
                                  } else {
                                    setState(() {
                                      errorSex = "";
                                    });
                                  }
                                  bool flag = true;
                                  if (!_passwordController.text
                                      .contains(_cPasswordController.text)) {
                                    setState(() {
                                      matchPasswordError = "Password not Match";
                                    });
                                    flag = false;
                                  } else {
                                    setState(() {
                                      matchPasswordError = "";
                                    });
                                    flag = true;
                                  }
                                  if (_formKey.currentState!.validate() &&
                                      errorAge.isEmpty &&
                                      errorSex.isEmpty &&
                                      flag) {
                                    DateFormat formatter =
                                        DateFormat('yyyy-MM-dd');
                                    String dobDate = formatter.format(dob);
                                    DashboardService.createNewAccount(
                                        RegisterUserModal(
                                      name: _fullNameController.text,
                                      dob: dobDate,
                                      email: _emailController.text,
                                      height: _heightController.text,
                                      password: _passwordController.text,
                                      weight: _weightController.text,
                                      sex: _selectedSex,
                                      userType: "user",
                                      deviceToken: deviceToken,
                                      username: _emailController.text,
                                    )).then((value) {
                                      if (value == null) {
                                        Get.defaultDialog(
                                            title: "Alert",
                                            content:
                                                Text("Account create error"));
                                      } else {
                                        if (value['status']) {
                                          print(value['user']);

                                          Map<String, dynamic> user =
                                              value['user'];
                                          box.write(
                                              StorageConstant.id, user['id']);
                                          box.write(StorageConstant.username,
                                              user['username']);
                                          box.write(StorageConstant.name,
                                              user['name']);
                                          box.write(
                                              StorageConstant.dob, user['dob']);
                                          box.write(StorageConstant.email,
                                              user['email']);
                                          box.write(StorageConstant.user_type,
                                              user['user_type']);
                                          box.write(StorageConstant.user_type,
                                              user['user_type']);
                                          box.write(StorageConstant.gender,
                                              user['sex']);
                                          box.write(StorageConstant.height,
                                              user['height']);
                                          box.write(StorageConstant.weight,
                                              user['weight']);
                                          box.write(StorageConstant.point,
                                              user['point']);
                                          box.write(StorageConstant.userStatus,
                                              user['user_status'] == "1");
                                          Get.defaultDialog(
                                            title: "Alert",
                                            content: Text("Account Created"),
                                            onConfirm: () {
                                              Get.to(HomePage());
                                            },
                                          );
                                        } else {
                                          Get.defaultDialog(
                                              title: "Alert",
                                              content: Text(value['msg']));
                                        }
                                      }
                                    });
                                    print("Else if");
                                  } else {
                                    print("Else Run");
                                  }
                                },
                                child: Text(
                                  "Sign Up",
                                  style: Get.theme.textTheme.headlineSmall!
                                      .copyWith(color: myWhite),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class TextFormFieldWithSizeBox extends StatelessWidget {
  const TextFormFieldWithSizeBox({
    super.key,
    required this.focusNode,
    required TextEditingController fullNameController,
    required this.validator,
    required this.label,
    this.inputFormatters,
    this.iconData,
    this.obscureText,
  }) : _fullNameController = fullNameController;

  final TextEditingController _fullNameController;
  final String? Function(String?) validator;
  final FocusNode? focusNode;
  final String? label;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? iconData;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          focusNode: focusNode,
          obscureText: obscureText ?? false,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              focusColor: myAccentColor,
              prefixIcon: Icon(
                iconData ?? Icons.person,
                color: focusNode!.hasFocus ? myAccentColor : Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(100),
                borderSide: new BorderSide(),
              ),
              hintText: label,
              labelText: label,
              labelStyle: TextStyle(
                  color: focusNode!.hasFocus ? myAccentColor : myBlack)),
          controller: _fullNameController,
          validator: validator,
        ),
        const SizedBox(
          height: myHeightSmall,
        ),
      ],
    );
  }
}
