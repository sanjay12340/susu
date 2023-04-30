import 'dart:developer';

import 'package:susu/models/bid_history_model.dart';

import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BidHistory extends StatefulWidget {
  BidHistory({Key? key}) : super(key: key);

  @override
  _BidHistoryState createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  double tableFontSize = 12;
  List<DropdownMenuItem<String>> dropdownList = [
    DropdownMenuItem(
      child: Text(
        "All Time",
        overflow: TextOverflow.ellipsis,
      ),
      value: "all",
    )
  ];

  List<DropdownMenuItem<String>> dropdownListType =
      List<DropdownMenuItem<String>>.empty(growable: true);
  List<DropdownMenuItem<String>> dropdownGameList =
      List<DropdownMenuItem<String>>.empty(growable: true);

  List<DropdownMenuItem<String>> _winLoosePandingList = [
    DropdownMenuItem(
      child: Text("All"),
      value: "all",
    ),
    DropdownMenuItem(
      child: Text("Win"),
      value: "win",
    ),
    DropdownMenuItem(
      child: Text("Loose"),
      value: "loose",
    ),
    DropdownMenuItem(
      child: Text("Pending"),
      value: "pending",
    ),
  ];

  RemoteGameResultService? remoteGameResultService;

  var _selectedValue = "all";
  var _selectedValueType = "all";
  var _selectedGame = "all";

  var _winLoosePanding = "all".obs;
  GenralApiCallService genralApiCallService = GenralApiCallService();
  final box = GetStorage();
  var listResults = List<BidHistoryModel>.empty(growable: true).obs;
  var futureResult = Future<List<BidHistoryModel?>?>.value().obs;

  @override
  void initState() {
    super.initState();

    remoteGameResultService = RemoteGameResultService();
    dropdownListType.add(DropdownMenuItem<String>(
      child: Text("Select Type"),
      value: "all",
    ));
    dropdownGameList.add(DropdownMenuItem<String>(
      child: Text("Select Game"),
      value: "all",
    ));
    getGameType();
  }

  Future<List<BidHistoryModel?>?> fetchGameResults(String sql) async {
    return await genralApiCallService.fetchGenralQuery(sql);
  }

  getAllResut(String sql) {
    futureResult.value = fetchGameResults(sql);
  }

  getGameType() async {
    await remoteGameResultService!.fetchGameType().then((value) {
      value!.gameTypeModel!.forEach((element) {
        dropdownListType.add(DropdownMenuItem<String>(
          child: Text(element.fname!),
          value: element.name,
        ));
      });
      value.gametime!.forEach((element) {
        dropdownList.add(DropdownMenuItem(
          child: Text(
            "${element.showTime}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(),
          ),
          value: element.time,
        ));
      });
      for (var element in value.game!) {
        dropdownGameList.add(DropdownMenuItem<String>(
          child: Text(element.gameName!),
          value: element.id!,
        ));
      }
    });
    setState(() {});
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
          "Bid History",
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: Get.width * 0.4,
                  child: DropdownButton<String>(
                      isExpanded: true,
                      onChanged: (value) {
                        _selectedGame = value!;
                        setState(() {});
                      },
                      value: _selectedGame,
                      items: dropdownGameList.map((val) => val).toList()),
                ),
                Container(
                  width: Get.width * 0.4,
                  padding: EdgeInsets.all(8),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      onChanged: (value) {
                        _selectedValue = value!;
                        setState(() {});
                      },
                      value: _selectedValue,
                      items: dropdownList.map((val) => val).toList()),
                ),
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Container(
                    width: Get.width * 0.4,
                    padding: EdgeInsets.all(8),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        onChanged: (value) {
                          _winLoosePanding.value = value!;
                        },
                        value: _winLoosePanding.value,
                        items: _winLoosePandingList.map((val) => val).toList()),
                  ),
                ),
                Container(
                  width: Get.width * 0.4,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [myPrimaryColorDark, myAccentColorDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                  child: TextButton(
                    child: Text("Search", style: TextStyle(color: myWhite)),
                    onPressed: () {
                      String filter =
                          " date >= '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' and date <='${selectedDate2.year}-${selectedDate2.month}-${selectedDate2.day}' ";
                      // var flag = true;

                      if (_selectedValueType != "all") {
                        filter += " AND  time = '$_selectedValueType' ";
                      }
                      if (_selectedGame != "all") {
                        filter += " AND  game_id = '$_selectedGame' ";
                      }
                      if (_winLoosePanding.value != "all") {
                        filter +=
                            " AND  win_loose = '${_winLoosePanding.value}' ";
                      }

                      String sql =
                          """SELECT sg.name,  `game_id`, `user_id`, `bid_amount`, `bid_number` , `win_loose` as status, `win_amount`, `game_type`, TIME_FORMAT(`time` , '%H:%i %p') as time , `date`, `created_at` FROM `startline_bid` 
                          inner join starline_game as sg on sg.id=game_id
                          WHERE user_id='${box.read("id")}' and $filter""";
                      print(sql);
                      getAllResut(sql);
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Table(border: TableBorder.all(), columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(0.8),
                2: FlexColumnWidth(0.6),
                3: FlexColumnWidth(0.6),
              }, children: [
                TableRow(children: [
                  myTableRawHead("Game", true, true, 15, 20),
                  myTableRawHead("Number", true, true, 15, 10),
                  myTableRawHead("Bid", true, true, 15, 10),
                  myTableRawHead("Win", true, true, 15, 10),
                ]),
              ]),
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<BidHistoryModel?>?>(
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
                            List<BidHistoryModel?>? finaldata = snapshot.data;
                            return (finaldata!.length == 0)
                                ? Container(
                                    child: Text("No Data Found!!"),
                                  )
                                : Container(
                                    color: Colors.grey.shade200,
                                    child: Table(
                                      border: TableBorder.all(color: myWhite),
                                      columnWidths: {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(0.8),
                                        2: FlexColumnWidth(0.6),
                                        3: FlexColumnWidth(0.6),
                                      },
                                      children: List.generate(finaldata.length,
                                          (index) {
                                        return TableRow(children: [
                                          myTableRaw(
                                              "${finaldata[index]!.name}\n" +
                                                  "${finaldata[index]!.gameType}\n" +
                                                  "Status : ${finaldata[index]!.status} \n" +
                                                  "Date : ${finaldata[index]!.date} \n" +
                                                  "Time : ${finaldata[index]!.time} \n",
                                              false,
                                              true,
                                              13,
                                              10),
                                          myTableRaw(
                                              finaldata[index]!.bidNumber!,
                                              true,
                                              true,
                                              15,
                                              10),
                                          myTableRaw(
                                              finaldata[index]!.bidAmount!,
                                              true,
                                              true,
                                              15,
                                              10),
                                          myTableRaw(
                                              finaldata[index]!.winAmount!,
                                              true,
                                              true,
                                              15,
                                              10),
                                        ]);
                                      }),
                                    ),
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
        padding: EdgeInsets.only(
          top: 10,
        ),
        color: Colors.grey.shade200,
        alignment: leftcenter ? Alignment.center : Alignment.topLeft,
        child: Text(
          text,
          textAlign: leftcenter ? TextAlign.center : TextAlign.left,
          style: TextStyle(fontSize: textsize, color: myBlack),
        ),
      ),
    );
  }
}

TableCell myTableRawHead(
    String text, bool type, bool leftcenter, double textsize, double padding) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      color: myPrimaryColorDark,
      height: 40,
      alignment: leftcenter ? Alignment.center : Alignment.topLeft,
      child: Text(
        text,
        textAlign: leftcenter ? TextAlign.center : TextAlign.left,
        style: TextStyle(fontSize: textsize, color: myWhite),
      ),
    ),
  );
}
