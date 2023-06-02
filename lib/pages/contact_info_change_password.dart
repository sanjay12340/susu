import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ContactInfoPagePassword extends StatelessWidget {
  final String? password;
  ContactInfoPagePassword({Key? key, this.password}) : super(key: key);
  final _formState = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();

  final GenralApiCallService g = GenralApiCallService();
  final box = GetStorage();
  final btn = "update".obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.all(20),
        child: Form(
            key: _formState,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: _oldPassword,
                    decoration: InputDecoration(
                      hintText: "Old Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: _newPassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "New Password"),
                    validator: (val) {
                      if (val!.length > 5 && val == _oldPassword.text) {
                        return null;
                      } else if (val != _oldPassword.text) {
                        return "Password should Match";
                      } else {
                        return "Password should be length 6";
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: myPrimaryColor,
                  width: Get.size.longestSide,
                  child: TextButton(
                      onPressed: () {
                        if (_formState.currentState!.validate()) {
                          btn.value = "Please Wait.....";
                          String sql =
                              "UPDATE `users` SET `password` = '${_newPassword.text.toString()}'  WHERE id ='${box.read('id')}' ";
                          g
                              .fetchGenralQueryNormal(
                                  sql, "Update success", "Update failure")
                              .then((value) {
                            if (value == "Update success") {
                              Get.defaultDialog(
                                  title: "Update Status",
                                  middleText: "Success",
                                  barrierDismissible: false,
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          box.write('password',
                                              _newPassword.text.toString());
                                          Get.back();
                                          Get.back<bool>(
                                            result: true,
                                          );
                                        },
                                        child: Text("ok"))
                                  ]);
                            } else {
                              Get.defaultDialog(
                                  title: "Update Status",
                                  middleText: "Failed",
                                  barrierDismissible: false,
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                          Get.back<bool>(
                                            result: false,
                                          );
                                        },
                                        child: Text("ok"))
                                  ]);
                            }
                          });
                        }
                      },
                      child: Obx(() => Text(
                            "${btn.value}",
                            style: TextStyle(color: myWhite, fontSize: 16),
                          ))),
                )
              ],
            )),
      ),
    );
  }
}
