import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome, ${box.read(StorageConstant.name)}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  gapHeightL2,
                  gapHeightL2,
                  Text(
                    "Your reports are evaluated.\n\nPlease share to minimum 3 persons to continue",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )),
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Back To Home"))
        ],
      ),
    );
  }
}
