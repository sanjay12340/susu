import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBox extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final String? number;
  final bool? leftView;
  MyBox({Key? key, @required this.number, this.leftView = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return leftView!
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    color: myPrimaryColorDark,
                  ),
                  alignment: Alignment.center,
                  child: Text("$number",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  margin: EdgeInsets.zero,
                ),
                Container(
                  color: myWhite,
                  width: 80,
                  margin: EdgeInsets.zero,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      isDense: true,
                      fillColor: myWhite,
                      focusColor: myWhite,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      hintStyle: TextStyle(
                        color: Colors.purple,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: myPrimaryColorDark,
                  ),
                  alignment: Alignment.center,
                  child: Text("$number",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  margin: EdgeInsets.zero,
                ),
                Container(
                  color: myWhite,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent)),
                      hintStyle: TextStyle(
                        color: Colors.purple,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
  }
}
