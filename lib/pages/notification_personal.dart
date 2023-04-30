import 'dart:developer';

import 'package:susu/services/genral_api_call.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/models/personal_notification_model.dart';
import 'package:get/get.dart';

import '../utils/storage_constant.dart';

class PersolNotifiaction extends StatefulWidget {
  PersolNotifiaction({Key? key}) : super(key: key);

  @override
  _PersolNotifiactionState createState() => _PersolNotifiactionState();
}

class _PersolNotifiactionState extends State<PersolNotifiaction> {
  GenralApiCallService? genralApiCallService;
  var box = GetStorage();
  bool one = true;
  String sql = "";
  String sqlData = "";
  @override
  void initState() {
    super.initState();
    genralApiCallService = GenralApiCallService();
    getNumberOffNotifiaction();
  }

  void getNumberOffNotifiaction() {
    sqlData =
        "SELECT ln.id, `notice`, `date`, `notice_to` , `view` FROM `user_notice` as un inner join live_notice as ln on ln.id=un.notice_id where user_id='${box.read(StorageConstant.id)}' order by ln.id desc limit 10";
    // "SELECT `id`, `notice`, `date`, `notice_to` FROM `live_notice` WHERE `id` in ($sql) order by id desc";
    log(sqlData, name: "Personal Notice sql");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back(canPop: true, result: true);
            }),
      ),
      body: FutureBuilder(
        future: genralApiCallService!.fetchGenralQueryWithRawData(sqlData),
        builder: (context, AsyncSnapshot<Object?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Container(child: Text("No Internet Conection")),
              );

            case ConnectionState.waiting:
              return Center(
                child: Container(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              );

            case ConnectionState.done:
              if (snapshot.hasData) {
                log("Data Revieve", name: snapshot.data.toString());

                List<PersonalNotifiactionModel> l =
                    personalNotifiactionModelFromJson(snapshot.data.toString());

                return ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          l[index].notice!,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${l[index].date!.day}-${l[index].date!.month}-${l[index].date!.year}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else
                return Text("data hai ");

            default:
              return Text("data hai ");
          }
        },
      ),
    );
  }
}
