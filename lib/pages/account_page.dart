import 'package:susu/pages/contact_info_page_bank.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'contact_info_change_password.dart';
import 'contact_info_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
              Card(
                elevation: 8,
                child: Container(
                  width: Get.width * 0.9,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        myPrimaryColor,
                        myAccentColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
              Container(
                  width: Get.width * 0.9,
                  child: Text(
                    "Username: ${box.read("username")}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "phonepe: ${box.read("phonepe")}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool? bol = await Get.to(() => ContactInfoPage(
                                name: "phonepe",
                                number: box.read("phonepe"),
                              ));
                          print(bol);
                          bol = bol ?? false;
                          if (bol == true) {
                            setState(() {});
                          }
                        },
                      )
                    ],
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "gpay: ${box.read("gpay")}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool bol = await Get.to(() => ContactInfoPage(
                                name: "gpay",
                                number: box.read("gpay"),
                              ));
                          print(bol);
                          if (bol == true) {
                            setState(() {});
                          }
                        },
                      )
                    ],
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "paytm: ${box.read("paytm")}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool bol = await Get.to(() => ContactInfoPage(
                                name: "paytm",
                                number: box.read("paytm"),
                              ));
                          print(bol);
                          if (bol == true) {
                            setState(() {});
                          }
                        },
                      )
                    ],
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bank",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          //`bank_name`, `account_number`, `ifsc`
                          bool bol = await Get.to(() => ContactInfoPageBank(
                              bankname: box.read("bank_name").toString(),
                              account: box.read("account_number").toString(),
                              ifsc: box.read("ifsc").toString()));
                          print(bol);
                          if (bol == true) {
                            setState(() {});
                          }
                        },
                      )
                    ],
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Text(
                    "Bank Name:  ${box.read("bank_name")}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Text(
                    "Bank A/c:  ${box.read("account_number")}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Container(
                  width: Get.width * 0.9,
                  child: Text(
                    "IFSC:  ${box.read("ifsc")}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              //
              //PAssword
              Container(
                width: Get.size.longestSide,
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: myPrimaryColorDark,
                    borderRadius: BorderRadius.circular(7)),
                child: TextButton(
                  child: Text(
                    "Change Password",
                    style: TextStyle(color: myWhite),
                  ),
                  onPressed: () async {
                    bool bol = await Get.to(() => ContactInfoPagePassword(
                          password: box.read("password"),
                        ));
                    print(bol);
                    if (bol == true) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
