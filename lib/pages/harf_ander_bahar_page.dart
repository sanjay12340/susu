import 'package:susu/models/my_box_modal.dart';
import 'package:susu/mywidgets/bet_box_game.dart';

import 'package:susu/utils/game_type_card.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:susu/models/bet_number_modal.dart';
import 'package:susu/models/game_play_condition_model.dart';
import 'package:susu/models/game_result_model.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/play_bet_service.dart';
import 'package:susu/utils/mycontant.dart';

import '../utils/storage_constant.dart';

class HarafAnderBahar extends StatefulWidget {
  final GameResultModel? gameResultModel;
  final String? name;
  final String? gametype;

  const HarafAnderBahar(
      {Key? key, @required this.gameResultModel, this.name, this.gametype})
      : super(key: key);

  @override
  _HarafAnderBaharState createState() => _HarafAnderBaharState();
}

class _HarafAnderBaharState extends State<HarafAnderBahar> {
  var balance = "0".obs;
  final box = GetStorage();
  final List<MyBox> n = [
    MyBox(
      number: "0",
    ),
    MyBox(
      number: "1",
    ),
    MyBox(
      number: "2",
    ),
    MyBox(
      number: "3",
    ),
    MyBox(
      number: "4",
    ),
    MyBox(
      number: "5",
    ),
    MyBox(
      number: "6",
    ),
    MyBox(
      number: "7",
    ),
    MyBox(
      number: "8",
    ),
    MyBox(
      number: "9",
    )
  ];

  List<BetNumberModal> _betList = List<BetNumberModal>.empty(growable: true);

  RemoteGameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  var isWaiting = true.obs;

  var opneClose = ["Select Market"].obs;
  var _selectedValue = "Select Market".obs;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    balance.value = box.read("money").toString();
    getBalance();
    getBidAmount();
  }

  int minBidAmount = 3;
  void getBidAmount() {
    if (box.read(StorageConstant.bidander) != null) {
      setState(() {
        minBidAmount = box.read(StorageConstant.bidJodi);
      });
    }
  }

  getBalance() async {
    rgrs = RemoteGameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];
      box.write("money", map["money"].toString());
    }

    gpcm = await rgrs!.checkPlayCondtion(int.parse(widget.gameResultModel!.id!),
        widget.gameResultModel!.closeTime!);
    if (gpcm!.playstatus!) {
      if (gpcm!.playoc == "open") {
        opneClose.value = ["Select Market", "open", "close"];
        _selectedValue.value = "close";
        isWaiting.value = false;
      } else if (gpcm!.playoc == "close") {
        opneClose.value = ["close"];
        _selectedValue.value = "close";
        isWaiting.value = false;
      }
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
          title: Text(widget.name!),
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
        body: Container(
          height: size.height,
          width: size.width,
          color: myPrimaryColorDark.withOpacity(0.2),
          child: SingleChildScrollView(
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
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: n.map((val) => val).toList(),
                ),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _betList.clear();
                      int total = 0;
                      n.forEach((i) {
                        if (i.controller.text.toString() != "") {
                          if (int.parse(i.controller.text.toString()) >=
                              minBidAmount) {
                            total += int.parse(i.controller.text.toString());
                            _betList.add(BetNumberModal(
                              gameid: int.parse(widget.gameResultModel!.id!),
                              openclose: _selectedValue.value.toString(),
                              date:
                                  "${timediff().year}-${timediff().month}-${timediff().day}",
                              time: widget.gameResultModel!.time,
                              gametype: widget.gametype,
                              number: i.number.toString(),
                              price: int.parse(i.controller.text.toString()),
                              userid: int.parse(box.read("id")),
                            ));
                          }
                        }
                      });

                      if (total < int.parse(balance.value)) {
                        if (total > 0) {
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                      color: Colors.red,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                widget.name!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                  "Date : ${timediff().day}-${timediff().month}-${timediff().year} ${widget.gameResultModel!.resultTime!}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            BetBoxGame(
                                              text: "Ank",
                                              textColor: myWhite,
                                            ),
                                            BetBoxGame(
                                              text: "Amount",
                                              textColor: myWhite,
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: SingleChildScrollView(
                                          child: Table(
                                            border: TableBorder.all(),
                                            children: _betList
                                                .map((val) =>
                                                    TableRow(children: [
                                                      BetBoxGame(
                                                        text: val.number!,
                                                        textColor: myBlack,
                                                      ),
                                                      BetBoxGame(
                                                        text: val.price!
                                                            .toString(),
                                                        textColor: myBlack,
                                                      ),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("$total",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                              TableRow(children: [
                                                Text(
                                                    "Before Bet Wallet Amount :",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("$balance",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                              TableRow(children: [
                                                Text(
                                                    "Before Bet Wallet Amount :",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "${int.parse(box.read("money")) - total}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
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
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
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
                                                  Map m =
                                                      await submitbet(_betList);
                                                  if (m["status"]) {
                                                    Get.back();
                                                    Get.defaultDialog(
                                                      barrierDismissible: false,
                                                      content: Container(
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                "Bet is Successfull"),
                                                            SizedBox(
                                                              height: 35,
                                                              width: 250,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  box.write(
                                                                      "money",
                                                                      (int.parse(balance.value) -
                                                                              total)
                                                                          .toString());
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text("Ok"),
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
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    Text("Ok"),
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
                    child: Container(
                      width: Get.width * 0.5,
                      alignment: Alignment.center,
                      child: Text(
                        "Submit".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
