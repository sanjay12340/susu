import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:susu/models/bet_number_half_full_modal.dart';

import 'package:susu/models/game_result_model.dart';
import 'package:susu/models/half_sangam_opne_bet_model.dart';

import 'package:susu/services/play_bet_service.dart';
import 'package:susu/utils/game_type_card.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:susu/utils/pana_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:susu/controllers/half_sangam_open_bet_controller.dart';

class HalfSangamOpen extends StatefulWidget {
  final GameResultModel? gameResultModel;
  final String? balance;

  HalfSangamOpen(
      {Key? key, required this.gameResultModel, required this.balance})
      : super(key: key);

  @override
  _HalfSangamOpenState createState() => _HalfSangamOpenState();
}

class _HalfSangamOpenState extends State<HalfSangamOpen> {
  var _sugessionText = TextEditingController();
  var _suggestionKey = GlobalKey<AutoCompleteTextFieldState>();
  var _ank = TextEditingController();
  var _amount = TextEditingController();
  final box = GetStorage();

  final String _selectedValue = "open";

  var _betListModel = List<HalfSangamOpenBetModel>.empty(growable: true).obs;
  List<BetNumberHalfFullModal> _betList =
      List<BetNumberHalfFullModal>.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  void add(HalfSangamOpenBetModel halfSangamOpenBetModel) {
    _betListModel.add(halfSangamOpenBetModel);
  }

  Future<Map<String?, dynamic>?> submitbet(
      List<BetNumberHalfFullModal> myjson) async {
    Map<String?, dynamic>? m = await PlayBet.playBetGameHalfFull(myjson);
    return m;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var d = DateTime.now();
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/pngbga.png"),
              repeat: ImageRepeat.repeat)),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GameTypeCard(
            name: "Half Sangam",
          ),
          Card(
            elevation: 8,
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoCompleteTextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        key: _suggestionKey,
                        clearOnSubmit: false,
                        controller: _sugessionText,
                        suggestions: panaList!,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 0, top: 25, left: 10),
                            isDense: true,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Pana",
                            labelText: "Pana"),
                        itemFilter: (items, query) {
                          return items.toString().startsWith(query.toString());
                        },
                        itemSorter: (a, b) {
                          return a.toString().compareTo(b.toString());
                        },
                        itemSubmitted: (item) {
                          _sugessionText.text = item.toString();
                        },
                        itemBuilder: (context, item) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text(
                                "$item",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _ank,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 0, top: 25, left: 10),
                            isDense: true,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Ank",
                            labelText: "Ank"),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Filed not Empity";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 0, top: 25, left: 10),
                            isDense: true,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Amount",
                            labelText: "Amount"),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Filed not Empity";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(color: myPrimaryColor),
            child: TextButton(
                onPressed: () {
                  print("Open Pana" + _sugessionText.text.toString());
                  print(
                      '''Open Pana ${panaList!.contains(int.parse(_sugessionText.text.toString()))}''');
                  if (_sugessionText.text.toString() != "" &&
                      _ank.text.toString() != "" &&
                      _amount.text.toString() != "") {
                    if (panaList!.contains(
                            int.parse(_sugessionText.text.toString())) &&
                        int.parse(_ank.text.toString()) > -1 &&
                        int.parse(_ank.text.toString()) < 10 &&
                        int.parse(_amount.text.toString()) > 9) {
                      add(HalfSangamOpenBetModel(
                          pana: _sugessionText.text,
                          ank: _ank.text,
                          amount: _amount.text));
                      _sugessionText.text = "";
                      _ank.text = "";
                      _amount.text = "";
                    } else {
                      if (!panaList!
                          .contains(int.parse(_sugessionText.text.toString())))
                        Get.defaultDialog(
                            title: "Alert",
                            middleText: "Please Provide Valid Pana");
                      else if (!(int.parse(_ank.text.toString()) > -1 &&
                          int.parse(_ank.text.toString()) < 10))
                        Get.defaultDialog(
                            title: "Alert",
                            middleText:
                                "Please Provide Valid Ank between 0 to 9");
                      else if (!(int.parse(_amount.text.toString()) > 9))
                        Get.defaultDialog(
                            title: "Alert",
                            middleText: "Min point should be 10");
                    }
                  } else {
                    Get.defaultDialog(
                        title: "Alert",
                        middleText:
                            "Please Provide Pana , Ank and Amount all Three");
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: myWhite),
                )),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Table(
                    columnWidths: {
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.black),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Open Pana",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Close Ank",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Amount",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Del",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ]),
                    ],
                  ),
                  Obx(() => Table(
                        columnWidths: {
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(0.5),
                        },
                        border: TableBorder.all(),
                        children: List.generate(
                          _betListModel.length,
                          (index) {
                            return TableRow(children: [
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  color: Colors.red.shade900,
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text(
                                    _betListModel[index].pana.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  color: Colors.green,
                                  child: Text(
                                    _betListModel[index].ank.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  color: Colors.purple,
                                  child: Text(
                                    _betListModel[index].amount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: InkWell(
                                  splashColor: Colors.red,
                                  onTap: () {
                                    removeAt(index);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ]);
                          },
                        ),
                      )),
                ],
              ),
            ),
          )),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(color: myPrimaryColor),
            child: TextButton(
              child: Text(
                "Submit",
                style: TextStyle(color: myWhite),
              ),
              onPressed: () {
// Submit
                _betList.clear();
                int total = 0;
                _betListModel.forEach((i) {
                  total += int.parse(i.amount.toString());
                  _betList.add(BetNumberHalfFullModal(
                    userid: int.parse(box.read("id")),
                    gameid: int.parse(widget.gameResultModel!.id!),
                    bidamount: int.parse(i.amount!),
                    gametype: "HalfSangam",
                    openclose: _selectedValue,
                    fn: i.pana,
                    fno: "",
                    snc: i.ank,
                    sn: "",
                    date: "${d.year}-${d.month}${d.day}",
                  ));
                });

                bool flag = true;
                print(
                    " my total money $total and ${box.read("money")}  pending ${int.parse(box.read("money")) - total} ");
                if (total > int.parse(box.read("money"))) {
                  flag = false;
                  Get.defaultDialog(
                      title: "Alert", middleText: "insuficiant Fund");
                }
                if (flag) {
                  Get.bottomSheet(
                      Container(
                        height: size.height - 100,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${widget.gameResultModel!.gameName}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      "Market : $_selectedValue",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Half Sangam",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      "Date : ${d.day}-${d.month}-${d.year}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade800,
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    Center(
                                      child: Text(
                                        "Pana",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Ank",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Center(
                                        child: Text("Amount",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold))),
                                  ]),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: SingleChildScrollView(
                                  child: Table(
                                    border: TableBorder.all(),
                                    children: _betList
                                        .map((val) => TableRow(children: [
                                              Center(
                                                child: Text(
                                                  "${val.fn}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  "${val.snc}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                  child: Text(
                                                      "${val.bidamount}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ]))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: double.infinity,
                              color: Colors.blue,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(5),
                                      1: FlexColumnWidth(3),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Text("Total Bet Amount : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text("$total",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                      TableRow(children: [
                                        Text("Before Bet Wallet Amount :",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text("${widget.balance}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                      TableRow(children: [
                                        Text("Before Bet Wallet Amount :",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "${int.parse(box.read("money")) - total}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                    ],
                                  ),
                                  Text(
                                    "After Submit your Bet it will not cancel",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 8,
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () async {
                                          Get.back();
                                          Get.defaultDialog(
                                            barrierDismissible: false,
                                            radius: 0,
                                            title: "Wait",
                                            content: Container(
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  CircularProgressIndicator(),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          "please Wait Bet is Processing"))
                                                ],
                                              ),
                                            ),
                                          );
                                          Map<String?, dynamic>? m =
                                              await submitbet(_betList);
                                          if (m!["status"]) {
                                            Get.back();
                                            Get.defaultDialog(
                                              barrierDismissible: false,
                                              content: Container(
                                                child: Column(
                                                  children: [
                                                    Text("Bet is Successfull"),
                                                    SizedBox(
                                                      height: 35,
                                                      width: 250,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          box.write(
                                                              "money",
                                                              (int.parse(box.read(
                                                                          "money")) -
                                                                      total)
                                                                  .toString());
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Ok"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            Get.back();
                                            Get.defaultDialog(
                                              content: Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        "Bet is Failed Try Again"),
                                                    SizedBox(
                                                      height: 35,
                                                      width: 250,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text("Ok"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text("Submit Bet"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                      barrierColor: Colors.white.withOpacity(0.3));
                }

// Submit end
              },
            ),
          ),
        ],
      ),
    );
  }

  void removeAt(int index) {
    _betListModel.removeAt(index);
  }
}
