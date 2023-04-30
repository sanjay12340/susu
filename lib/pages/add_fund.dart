import 'dart:convert';
import 'package:susu/pages/home_page.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/services/genral_api_call.dart';
import 'package:susu/utils/value_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';
import 'package:susu/utils/links.dart';
import 'add_point_history.dart';
import 'package:upi_india/upi_india.dart';
import 'package:date_time_format/date_time_format.dart';

class AddFund extends StatefulWidget {
  AddFund({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AddFundState createState() => _AddFundState();
}

class _AddFundState extends State<AddFund> {
  var callback = "".obs;
  String? u2 = "";
  int _minAmount = 10;
  TextEditingController? _amountController;
  GenralApiCallService? genralApiCallService;
  List<UpiApp>? apps;
  Future<UpiResponse>? _transaction;
  List<String> rules = [
    "Type amount in box",
    "Amount should me 50 minimum"
        "Press Icon By which mode you add money",
    "Then it will redirect to Gatway",
    "As you finish your Trasction then point will Automatically update",
    "If You found any problem please send me you screen shot on my whats app",
    "We slove your traction with in couple of minute"
  ];

  var box = GetStorage();
  final dateTime = DateTime.now();

  final _formState = GlobalKey<FormState>();
  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  RemoteGameResultService? _remoteGameResultService;
  @override
  void initState() {
    super.initState();

    genralApiCallService = GenralApiCallService();
    _amountController = TextEditingController();
    checkRozarPay();
    getAppVersion();
    getBalance();
    getBlockUpi();
  }

  void getBlockUpi() {
    GenralApiCallService.blockUpi().then((blockUpiList) => {
          _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
            setState(() {
              apps = value
                  .where(
                      (app) => !blockUpiList.contains(app.name.toLowerCase()))
                  .toList();
            });
          }).catchError((e) {
            apps = [];
          })
        });
  }

  getBalance() async {
    _remoteGameResultService = RemoteGameResultService();
    Map map = await _remoteGameResultService!.checkBalance();
    if (map["status"]) {
      box.write("money", map["money"].toString());

      setState(() {});
      // balance.value = int.parse(box.read("money"));
    }
  }

  getAppVersion() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `id`, `version`, `date`, `massage`, `share_link` FROM `app_version`")
        .then((value) {
      print(value);
      var data = jsonDecode(value);
      var box = GetStorage();
      box.write(ValueConstant.upi, data[0]['massage']);
      setState(() {});
    });
  }

  checkRozarPay() {
    if (box.read(ValueConstant.upi) == null) {
      Get.offAll(() => HomePage());
    } else {
      print(box.read(ValueConstant.upi));
    }
  }

  var upb = true;
  _handlePaymentSuccesss(String resCode, String txnId) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (resCode == "s") {

      callback.value = callback.value +
          "Updating Balance please wait... handlePaymentSuccesss()\n";
      Get.defaultDialog(
          title: "Updating Balance",
          middleText: "Please Wait...",
          barrierDismissible: false);
      updateBalance();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final UpiIndia _upiIndia = UpiIndia();

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: box.read("rozar") ?? "no",
      receiverName: appname.toUpperCase(),
      transactionRefId: box.read("id") +
          "" +
          DateTimeFormat.format(dateTime, format: 'dmYhiA'),
      transactionNote: 'u',
      amount: double.parse(_amountController!.text),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  if (_amountController!.text != "") {
                    if (int.parse(_amountController!.text) > _minAmount) {
                      _transaction = initiateTransaction(app);
                      setState(() {});
                    } else {
                      Get.defaultDialog(
                          title: "Amount",
                          middleText: "Amount Should Be 10 or greater");
                    }
                  } else {
                    Get.defaultDialog(
                        title: "Amount", middleText: "Please Provide Input");
                  }
                },
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status, String resCode, String txnId) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        _handlePaymentSuccesss(resCode, txnId);
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  void updateBalance() {
    genralApiCallService!
        .addfundRozarPay(_amountController!.text.toString())
        .then((value) {
      var box = GetStorage();
      callback.value = callback.value + "Please Wait Balance updating\n";
      callback.value = callback.value + "${value!}\n";
      u2 = value;

      if (value.contains('yes')) {
        callback.value = callback.value + "Balance Must Updated\n";
        int money = int.parse(box.read("money"));
        int money2 = int.parse(_amountController!.text);
        int total = money + money2;
        box.write("money", "$total");

        callback.value =
            callback.value + "Balance Must Updated ${box.read("money")}\n";

        Get.back();
        // Get.offAll(() => HomePage());
      } else {
        callback.value = callback.value + "Else Called Balance Not Update";
        u2 = u2! +
            " value.toLowerCase().contains('yes') == ${value.toLowerCase().contains("yes")}";

        Get.back();
      }
    }).onError((error, stackTrace) {
      callback.value = callback.value +
          "Error comes in Updated Balance ${error.toString()} stackTrace : ${stackTrace.toString()}\n";
      //Get.offAll(() => HomePage());
    }).whenComplete(() {
      callback.value = callback.value + "Whene Complete State ment called\n";
      Get.offAll(() => HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(() => HomePage());
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                    onPressed: () {
                      Get.to(() => AddPointHistory());
                    },
                    child: Text("History")),
                TextButton(onPressed: () {}, child: Text("Help")),
              ]),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formState,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _transaction,
                      builder: (BuildContext context,
                          AsyncSnapshot<UpiResponse> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                _upiErrorHandler(snapshot.error.runtimeType),
                                style: header,
                              ), // Print's text message on screen
                            );
                          }

                          // If we have data then definitely we will have UpiResponse.
                          // It cannot be null
                          UpiResponse _upiResponse = snapshot.data!;

                          // Data in UpiResponse can be null. Check before printing
                          String txnId = _upiResponse.transactionId ?? 'N/A';
                          String resCode = _upiResponse.responseCode ?? 'N/A';
                          String txnRef =
                              _upiResponse.transactionRefId ?? 'N/A';
                          String status = _upiResponse.status ?? 'N/A';
                          String approvalRef =
                              _upiResponse.approvalRefNo ?? 'N/A';
                          _checkTxnStatus(status, resCode, txnId);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                displayTransactionData('Transaction Id', txnId),
                                displayTransactionData(
                                    'Response Code', resCode),
                                displayTransactionData('Reference Id', txnRef),
                                displayTransactionData(
                                    'Status', status.toUpperCase()),
                                displayTransactionData(
                                    'Approval No', approvalRef),
                              ],
                            ),
                          );
                        } else
                          return Center(
                            child: Text(''),
                          );
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: "Amount",
                          labelText: "Amount",
                          border: OutlineInputBorder()),
                      controller: _amountController,
                      validator: (val) {
                        if (int.parse(val!) < _minAmount) {
                          return "Amount must be greater then $_minAmount";
                        } else {
                          return null;
                        }
                      },
                    ),
                    // ElevatedButton(onPressed: checkout, child: Text("Add Point")),

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: rules.length,
                              itemBuilder: (_, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}. ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                        child: Text(
                                      rules[index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ],
                                );
                              }),
                        ]),

                    Container(
                      child: displayUpiApps(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
