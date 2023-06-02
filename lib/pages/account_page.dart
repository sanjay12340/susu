import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:susu/pages/contact_info_page_bank.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/utils/storage_constant.dart';

import 'contact_info_change_password.dart';
import 'contact_info_page.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _cPasswordController = TextEditingController();
  final TextEditingController _ref = TextEditingController();
  final TextEditingController _phone = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dob = DateTime.parse(box.read(StorageConstant.dob));
      _age = "${calculateAge(dob)} years";
      _fullNameController.text = box.read(StorageConstant.name);
      _selectedSex = box.read(StorageConstant.gender);
      _heightController.text = box.read(StorageConstant.height);
      _weightController.text = box.read(StorageConstant.weight);
    });
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

  bool validateEmail(String email) {
    // Define the regex pattern for an email address
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    // Create a RegExp object from the pattern
    final regExp = RegExp(pattern);

    // Use the RegExp object to match the email string
    return regExp.hasMatch(email);
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width * 0.9,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Image.asset(
                        "assets/images/boy.png",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                                children: [
                              TextSpan(text: "Name: "),
                              TextSpan(text: box.read(StorageConstant.name))
                            ])),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                children: [
                              TextSpan(text: "Email: "),
                              TextSpan(text: box.read(StorageConstant.username))
                            ]))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width * 0.9,
                child: Column(
                  children: [
                    TextFormFieldWithSizeBox(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(children: [
                          Icon(
                            Icons.person,
                            color:
                                errorAge.isEmpty ? Colors.black54 : Colors.red,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      fullNameController: _heightController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      label: "Height (in cm)",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "height can't Empty ";
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWithSizeBox(
                      fullNameController: _weightController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      label: "Weight (in Kg)",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Weight can't Empty ";
                        }
                        return null;
                      },
                      iconData: FontAwesomeIcons.dumbbell,
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

                            if (true) {
                              DateFormat formatter = DateFormat('yyyy-MM-dd');
                              String dobDate = formatter.format(dob);
                              DashboardService.updateUserInfo(
                                      dob: dobDate,
                                      name: _fullNameController.text,
                                      gender: _selectedSex,
                                      height: _heightController.text,
                                      weight: _weightController.text)
                                  .then((value) {
                                if (value == null) {
                                  Get.defaultDialog(
                                      title: "Alert",
                                      content: Text("Info Update Error"));
                                } else {
                                  if (value['status']) {
                                    print(value['user']);

                                    Map<String, dynamic> user = value['user'];
                                    box.write(
                                        StorageConstant.name, user['name']);
                                    box.write(StorageConstant.dob, user['dob']);
                                    box.write(
                                        StorageConstant.gender, user['sex']);
                                    box.write(
                                        StorageConstant.height, user['height']);
                                    box.write(
                                        StorageConstant.weight, user['weight']);

                                    Get.defaultDialog(
                                      title: "Alert",
                                      confirmTextColor: Colors.black87,
                                      content: Text("Info Updated"),
                                      onConfirm: () {
                                        Get.offAll(HomePage());
                                      },
                                    );
                                  } else {
                                    // Get.defaultDialog(
                                    //     title: "Alert",
                                    //     content: Text(value['msg']));
                                  }
                                }
                              });
                              print("Else if");
                            } else {
                              print("Else Run");
                            }
                          },
                          child: Text(
                            "Update Info",
                            style: Get.theme.textTheme.headlineSmall!
                                .copyWith(color: myWhite, fontSize: 18),
                          )),
                    )
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

class TextFormFieldWithSizeBox extends StatelessWidget {
  const TextFormFieldWithSizeBox({
    super.key,
    required TextEditingController fullNameController,
    required this.validator,
    required this.label,
    this.inputFormatters,
    this.iconData,
    this.obscureText,
  }) : _fullNameController = fullNameController;

  final TextEditingController _fullNameController;
  final String? Function(String?) validator;

  final String? label;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? iconData;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: obscureText ?? false,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            focusColor: myAccentColor,
            prefixIcon: Icon(
              iconData ?? Icons.person,
            ),
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(100),
              borderSide: new BorderSide(),
            ),
            hintText: label,
            labelText: label,
          ),
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
