import 'package:susu/models/get_transaction_model.dart';

import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WithdrawPointHistory extends StatefulWidget {
  WithdrawPointHistory({Key? key}) : super(key: key);

  @override
  _WithdrawPointHistoryState createState() => _WithdrawPointHistoryState();
}

class _WithdrawPointHistoryState extends State<WithdrawPointHistory> {
  double tableFontSize = 12;
  List<DropdownMenuItem<String>> dropdownList = [
    DropdownMenuItem(
      child: Text(
        "All Game",
        overflow: TextOverflow.ellipsis,
      ),
      value: "all",
    )
  ];

  List<DropdownMenuItem<String>> dropdownListType =
      List<DropdownMenuItem<String>>.empty(growable: true);

  RemoteGameResultService? remoteGameResultService;

  GenralApiCallService genralApiCallService = GenralApiCallService();
  final box = GetStorage();
  var listResults = List<GetTransation>.empty(growable: true).obs;
  var futureResult = Future<List<GetTransation?>?>.value().obs;

  @override
  void initState() {
    super.initState();

    remoteGameResultService = RemoteGameResultService();
    dropdownListType.add(DropdownMenuItem<String>(
      child: Text("Select Type"),
      value: "all",
    ));
  }

  Future<List<GetTransation?>?> fetchGameResults(String sql) async {
    return await genralApiCallService.fetchTransactionAddAmount(sql);
  }

  getAllResut(String sql) {
    futureResult.value = fetchGameResults(sql);
  }

  var selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  var selectedDate2 = DateTime.now();
  _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Widthdraw Point History",
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: Get.width * 0.4,
                  color: Colors.grey.shade300,
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "From ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      )),
                ),
                Container(
                  width: Get.width * 0.4,
                  color: Colors.grey.shade300,
                  height: 40,
                  child: GestureDetector(
                      onTap: () => _selectDate2(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "To ${selectedDate2.day}-${selectedDate2.month}-${selectedDate2.year} ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [myPrimaryColor, myAccentColor])),
              child: TextButton(
                child: Text(
                  "Filter",
                  style: TextStyle(color: myWhite, fontSize: 16),
                ),
                onPressed: () {
                  var filter = "";
                  // var flag = true;

                  filter +=
                      " date >= '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' and date <='${selectedDate2.year}-${selectedDate2.month}-${selectedDate2.day}' ";

                  String sql =
                      "SELECT `id`, `user_id` as userId, `c_amount` as cAmount , `credit`, `debit`, `final_amount` as finalAmount , `date`, `created_at` as createdAt, `comment`, `uids` FROM `transaction`  WHERE comment LIKE '%withdaw%' and" +
                          filter +
                          " and user_id = '${box.read("id")}'";
                  print(sql);
                  getAllResut(sql);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: myPrimaryColor,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Date",
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Widthdraw Point",
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ]),
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<GetTransation?>?>(
                    future: futureResult.value,
                    builder: (context, snapshot) {
                      print(snapshot.connectionState);
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          print("No Internet Connection");
                          break;
                        case ConnectionState.waiting:
                          return Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            List<GetTransation?>? finaldata = snapshot.data;
                            print(
                                "Finad Lenght of data ----  ${finaldata!.length}");
                            return (finaldata.length == 0)
                                ? Container(
                                    child: Text("No Data Found!!"),
                                  )
                                : Column(
                                    children: List.generate(finaldata.length,
                                        (index) {
                                      return Container(
                                        color: myPrimaryColor,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      finaldata[index]!.date!,
                                                      style: TextStyle(
                                                        color: myWhite,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      "-${finaldata[index]!.debit!}",
                                                      style: TextStyle(
                                                        color: myWhite,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              color: myAccentColor,
                                              padding: EdgeInsets.all(6),
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "pervious Point ${finaldata[index]!.cAmount!}",
                                                  style: TextStyle(
                                                    color: myWhite,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                            Container(
                                              color: myAccentColor,
                                              padding: EdgeInsets.all(6),
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "Total Point ${finaldata[index]!.finalAmount!}",
                                                  style: TextStyle(
                                                    color: myWhite,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                          } else {
                            print(snapshot.error);
                          }
                          break;
                        default:
                          if (snapshot.hasData) {
                            print("has data Default");
                          } else {
                            print(snapshot.error);
                          }
                      }

                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableCell myTableRaw(String text, bool type, bool leftcenter, double textsize,
      double padding) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        alignment: leftcenter ? Alignment.center : Alignment.topLeft,
        child: Text(
          text,
          textAlign: leftcenter ? TextAlign.center : TextAlign.left,
          style: TextStyle(fontSize: textsize),
        ),
      ),
    );
  }
}
