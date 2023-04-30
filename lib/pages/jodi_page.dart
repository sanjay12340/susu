import 'package:susu/models/my_box_modal.dart';

import 'package:susu/utils/game_type_card.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:susu/models/bet_number_modal.dart';
import 'package:susu/models/game_play_condition_model.dart';
import 'package:susu/models/game_result_model.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/play_bet_service.dart';

import '../utils/storage_constant.dart';

class JodiPage extends StatefulWidget {
  final GameResultModel? gameResultModel;

  const JodiPage({Key? key, @required this.gameResultModel}) : super(key: key);

  @override
  _JodiPageState createState() => _JodiPageState();
}

class _JodiPageState extends State<JodiPage> {
  var balance = "0".obs;
  final box = GetStorage();
  final List<MyBox> n = [];

  List<BetNumberModal> _betList = List<BetNumberModal>.empty(growable: true);

  RemoteGameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  TextEditingController number = TextEditingController();
  TextEditingController amount = TextEditingController();
  var isWaiting = true.obs;

  var opneClose = ["Select Market"].obs;
  var _selectedValue = "Select Market".obs;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    balance.value = box.read("money").toString();
    getBalance();
    jodiDat();
    getBidAmount();
  }

  int minBidAmount = 3;
  void getBidAmount() {
    if (box.read(StorageConstant.bidJodi) != null) {
      setState(() {
        minBidAmount = box.read(StorageConstant.bidJodi);
      });
    }
  }

  void jodiDat() {
    for (int i = 0; i < 100; i++) {
      n.add(MyBox(
        number: (i < 10) ? "0$i" : i.toString(),
        leftView: false,
      ));
    }
  }

  getBalance() async {
    rgrs = RemoteGameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];
      box.write("money", map["money"].toString());
    }
    print(widget.gameResultModel!.toJson());

    gpcm = await rgrs!.checkPlayCondtion(int.parse(widget.gameResultModel!.id!),
        widget.gameResultModel!.closeTime!);
    if (gpcm!.playstatus!) {
      opneClose.value = ["open"];
      _selectedValue.value = opneClose[0];
      isWaiting.value = false;
    } else {
      Get.back();
    }
  }

  Future<Map<String, dynamic>> submitbet(List<BetNumberModal> myjson) async {
    Map<String, dynamic> m = await PlayBet.playBetGame(myjson);
    return m;
  }

  DateTime timediff() {
    DateTime currentTime = DateTime.now();
    String month = (currentTime.month < 10)
        ? "0${currentTime.month}"
        : currentTime.month.toString();
    String day = (currentTime.day < 10)
        ? "0${currentTime.day}"
        : currentTime.day.toString();
    String yearMonthDate = "${currentTime.year}-$month-$day";
    DateTime closeTime =
        DateTime.parse("$yearMonthDate ${widget.gameResultModel!.closeTime}");
    var timeDiff = closeTime.difference(currentTime);
    if (timeDiff.inMinutes < 0) {
      DateTime d = (widget.gameResultModel!.nextday == "1")
          ? DateTime.now().add(Duration(hours: 24))
          : DateTime.now();
      return d;
    } else {
      return currentTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("Jodi"),
          actions: [
            Icon(Icons.account_balance_wallet),
            SizedBox(
              width: 10,
            ),
            Obx(
              () => Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${balance.value}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        bottomSheet: Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(color: myPrimaryColor),
          child: TextButton(
            onPressed: () {
              _betList.clear();
              int total = 0;
              n.forEach((i) {
                if (i.controller.text.toString() != "") {
                  if (int.parse(i.controller.text.toString()) >= minBidAmount) {
                    total += int.parse(i.controller.text.toString());
                    _betList.add(BetNumberModal(
                      gameid: int.parse(widget.gameResultModel!.id!),
                      openclose: "close",
                      date:
                          "${timediff().year}-${timediff().month}-${timediff().day}",
                      gametype: "jodi",
                      time: widget.gameResultModel!.time,
                      number: i.number.toString(),
                      price: int.parse(i.controller.text.toString()),
                      userid: int.parse(box.read("id")),
                    ));
                  }
                }
              });

              if (total < int.parse(balance.value)) {
                if (total > 1) {
                  Get.bottomSheet(
                      Container(
                        height: size.height - 100,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: myPrimaryColorDark,
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
                                ],
                              ),
                            ),
                            Container(
                              color: myAccentColorDark,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        "Jodi",
                                        style: TextStyle(
                                            color: myBlack,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Date : ${timediff().day}-${timediff().month}-${timediff().year} ${widget.gameResultModel!.resultTime}",
                                          style: TextStyle(
                                              color: myBlack,
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
                                        "Jodi",
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
                                                  "${val.number}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                  child: Text("${val.price}",
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
                                        Text("$balance",
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
                                          Map m = await submitbet(_betList);
                                          if (m["status"]) {
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
                                                              (int.parse(balance
                                                                          .value) -
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
                                        child: Text(
                                          "Submit Bet",
                                        ),
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
                } else {
                  Get.defaultDialog(
                      title: "Alert",
                      middleText: (total > 0)
                          ? "Select Bazar"
                          : (int.parse(balance.value) < 1)
                              ? "You dont have enough point to play please Recharge"
                              : "Please select at least one number min 1 point");
                }
              } else {
                Get.defaultDialog(
                    title: "Alert", middleText: "Insuficiant Fund");
              }
            },
            child: Text("Submit", style: TextStyle(color: myWhite)),
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          color: myPrimaryColor.withOpacity(0.1),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 8,
                shadowColor: Colors.white,
                child: Container(
                  width: size.width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${timediff().day}/${timediff().month}/${timediff().year}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: myBlack,
                            fontSize: 17),
                      ),
                      Text(
                        widget.gameResultModel!.resultTime!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: myBlack,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: myWhite,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: number,
                        decoration: InputDecoration(
                          hintText: "Numbers",
                          contentPadding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          isDense: true,
                          fillColor: myWhite,
                          focusColor: myWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: "Amount",
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
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          var s = number.text;
                          var amt = amount.text;
                          if (amt != "" && s != "") {
                            var s2 = s.split(",");

                            s2.forEach((i) {
                              if (i.contains("-")) {
                                var num = i.split("-");
                                var first = int.parse(num[0]);
                                var last = int.parse(num[1]);
                                for (int x = first; x <= last; x++) {
                                  var elementAt = n.removeAt(x);
                                  int val = elementAt.controller.text == null ||
                                          elementAt.controller.text == ""
                                      ? 0
                                      : int.parse(elementAt.controller.text);
                                  elementAt.controller.text =
                                      (val + int.parse(amt)).toString();
                                  print("inset at $x");
                                  n.insert(x, elementAt);
                                }
                              } else {
                                MyBox elementAt = n.removeAt(int.parse(i));
                                int val = elementAt.controller.text == null ||
                                        elementAt.controller.text == ""
                                    ? 0
                                    : int.parse(elementAt.controller.text);
                                elementAt.controller.text =
                                    (val + int.parse(amt)).toString();
                                n.insert(int.parse(i), elementAt);
                              }
                            });
                          } else {
                            Get.defaultDialog(
                                title: "Alert",
                                middleText:
                                    "Please fill  number and amount field",
                                textCancel: "Ok");
                          }
                        },
                        child: Text("Set"))
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
                  crossAxisSpacing: 0,
                  physics: BouncingScrollPhysics(),
                  children: n.map((val) => val).toList(),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ));
  }
}
