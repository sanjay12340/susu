import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:susu/models/add_withdraw_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_point_history.dart';
import 'widthdraw_point_history.dart';

class AddWidthdrawPage extends StatefulWidget {
  final String name;
  final String addWidthdraw;
  final String requestType;
  final String requestTypeFullName;
  final String adminwp;

  AddWidthdrawPage(
      {Key? key,
      required this.addWidthdraw,
      required this.requestType,
      required this.requestTypeFullName,
      required this.adminwp,
      required this.name})
      : super(key: key);

  @override
  _AddWidthdrawPageState createState() => _AddWidthdrawPageState();
}

class _AddWidthdrawPageState extends State<AddWidthdrawPage> {
  var box;

  GenralApiCallService? genralApiCallService;
  var _formState = GlobalKey<FormState>();
  var _selectedItem = "no".obs;
  var _amount = TextEditingController();
  var _phone = TextEditingController();
  var _minAddPint = 200;
  var _minWidthdraw = 100;
  TextStyle headingTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle headingTextStyle2 =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    box = GetStorage();
    genralApiCallService = GenralApiCallService();
  }

  Future<String> getData() async {
    String sql =
        "SELECT `wr_id`, `w_user_id`, `r_money`, `r_type`, `r_type2`, `payment_type`, `payment_link`, `status`, date_format(`created_at`,'%d-%m-%Y \n %h:%i %p') as created_at, `update_at` FROM `wallet_request` WHERE `w_user_id` =${box.read('id')} and r_type='${widget.requestType}' order by wr_id desc LIMIT 40";
    print(sql);
    return await genralApiCallService!.fetchGenralQueryWithRawData(sql);
  }

  void _launchURL(String msg) async =>
      await canLaunch("https://wa.me/${widget.adminwp}?text=$msg")
          ? await launch("https://wa.me/${widget.adminwp}?text=$msg")
          : throw 'Could not launch https://wa.me/${widget.adminwp}?text=$msg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.addWidthdraw.toUpperCase()}"),
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.center,
                color: myPrimaryColor,
                width: Get.width,
                padding: EdgeInsets.all(10),
                child: Text(
                  "${widget.addWidthdraw} Request",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            Container(
              width: Get.width,
              child: Form(
                key: _formState,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _amount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: "Amount",
                                labelText: "Amount",
                                border: OutlineInputBorder()),
                            validator: (widget.name.toLowerCase() == "withdraw")
                                ? (val) {
                                    if (val == "") {
                                      return "Min $_minWidthdraw";
                                    }
                                    if (int.parse(val!) < _minWidthdraw) {
                                      return "Min $_minWidthdraw";
                                    } else
                                      return null;
                                  }
                                : (val) {
                                    if (val == "") {
                                      return "Min $_minAddPint";
                                    }
                                    if (int.parse(val!) < _minAddPint) {
                                      return "Min $_minAddPint";
                                    } else
                                      return null;
                                  },
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _phone,
                            validator: (val) {
                              if (val!.length == 10) {
                                return null;
                              } else
                                return "Invalid Number";
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: "Phone Number",
                                labelText: "Phone Number",
                                border: OutlineInputBorder()),
                          ),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Expanded(
                              child: Container(
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              validator: (val) {
                                if (val == "no") {
                                  return "Select Payment Mode";
                                }
                                return null;
                              },
                              value: _selectedItem.value.toString(),
                              onChanged: (val) {
                                _selectedItem.value = val!;
                              },
                              items: const [
                                DropdownMenuItem(
                                  child: Text(
                                    "Select Mode",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  value: "no",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Paytm",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  value: "paytm",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Gpay",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  value: "gpay",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "PhonePe",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  value: "phonepe",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "UPI",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  value: "upi",
                                ),
                              ],
                            ),
                          )),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            color: myPrimaryColor,
                            child: TextButton(
                              child: Text(
                                "Send Requiest",
                                style: TextStyle(color: myWhite),
                              ),
                              onPressed: () {
                                if (_formState.currentState!.validate()) {
                                  var d = DateTime.now();
                                  String fullDate =
                                      "${d.year}-${(d.month < 10) ? "0" + d.month.toString() : d.month}-${(d.day < 10) ? "0" + d.day.toString() : d.day} ${(d.hour < 10) ? "0" + d.hour.toString() : d.hour}:${(d.minute < 10) ? "0" + d.minute.toString() : d.minute}:${(d.second < 10) ? "0" + d.second.toString() : d.second}";
                                  String sql =
                                      "INSERT INTO `wallet_request`(`w_user_id`, `r_money`, `r_type`, `r_type2`, `payment_type`, `payment_link`, `created_at`, `update_at`) VALUES ('${box.read('id')}','${_amount.text.toString()}','${widget.requestType.toString()}','${widget.requestTypeFullName..toString()}','${_selectedItem.value.toString()}', '${_phone.text.toString()}','$fullDate','$fullDate')";
                                  genralApiCallService!
                                      .fetchGenralQueryNormal(
                                          sql,
                                          "Requiest Send Successfull",
                                          "Requiest Send Failed")
                                      .then((value) {
                                    if (value == "Requiest Send Successfull") {
                                      getData();
                                      Get.defaultDialog(
                                          title: "Alert",
                                          middleText: (widget.name
                                                      .toLowerCase() ==
                                                  "withdraw")
                                              ? "withdraw request successful"
                                              : "Add request successful",
                                          textConfirm: "Ok",
                                          onConfirm: () {
                                            String msg =
                                                "${widget.name} Request \n Point:${_amount.text} \n Phone : ${_phone.text} \n Via : $_selectedItem";
                                            _launchURL(msg);
                                          });

                                      setState(() {});
                                    } else {
                                      Get.defaultDialog(
                                          title: "Alert",
                                          textCancel: "Ok",
                                          middleText:
                                              "Send Requiest Failed Please Contact To Admin");
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          color: Colors.green,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Phone Pe, GPay, PayTm >>",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("${box.read('whatsapp')}"),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (widget.requestType == "add_money")
                      ? TextButton(
                          onPressed: () {
                            Get.to(() => AddPointHistory());
                          },
                          child: Text(
                            "Add History >",
                            style: TextStyle(color: myPrimaryColor),
                          ))
                      : TextButton(
                          onPressed: () {
                            Get.to(() => WithdrawPointHistory());
                          },
                          child: Text(
                            "Withdraw History >",
                            style: TextStyle(color: myPrimaryColor),
                          ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                  child: SingleChildScrollView(
                child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container(child: Text("No Internet Connection"));

                      case ConnectionState.waiting:
                        return Container(
                            width: 20,
                            height: 20,
                            child: Center(child: CircularProgressIndicator()));

                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          List<AddWithDrawModel> l = addWithDrawModelFromJson(
                              snapshot.data.toString());
                          print("Lenght ${l.length}");
                          if (l.length == 0) {
                            return Container(child: Text("No Data Found!!!"));
                          } else if (l.length > 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                    color: myPrimaryColor,
                                    child: Table(
                                        border: TableBorder.all(
                                            color: myAccentColor),
                                        children: [
                                          TableRow(children: [
                                            TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  "Money",
                                                  textAlign: TextAlign.center,
                                                  style: headingTextStyle
                                                      .copyWith(color: myWhite),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  "Status",
                                                  textAlign: TextAlign.center,
                                                  style: headingTextStyle
                                                      .copyWith(color: myWhite),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Text(
                                                  "Date",
                                                  textAlign: TextAlign.center,
                                                  style: headingTextStyle
                                                      .copyWith(color: myWhite),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ]),
                                  ),
                                  Table(
                                      border:
                                          TableBorder.all(color: myAccentColor),
                                      children: l
                                          .map((e) => TableRow(children: [
                                                TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    child: Center(
                                                      child: Text(
                                                          e.rMoney.toString()),
                                                    )),
                                                TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    child: Center(
                                                      child: Text(
                                                          e.status.toString()),
                                                    )),
                                                TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4),
                                                        child: Text(
                                                          e.updateAt.toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )),
                                              ]))
                                          .toList()),
                                ],
                              ),
                            );
                          } else {
                            return Container(child: Text("other"));
                          }
                        } else {
                          return Container(child: Text("No Data Found!!!"));
                        }

                      default:
                        return Container(child: Text("Data"));
                    }
                  },
                ),
              )),
            ),
          ],
        ));
  }
}
