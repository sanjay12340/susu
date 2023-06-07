import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/lab_pages/lab_submit_test_result.dart';
import 'package:susu/lab_pages/lab_test_list.dart';
import 'package:susu/models/calorie_history_detail_modal.dart';
import 'package:susu/models/result_variables_modal.dart';
import 'package:susu/models/test_data_modal.dart';
import 'package:susu/pages/Login.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/links.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';

class LabHomePage extends StatefulWidget {
  const LabHomePage({Key? key}) : super(key: key);

  @override
  _LabHomePageState createState() => _LabHomePageState();
}

class _LabHomePageState extends State<LabHomePage> {
  List<ResultVariablesModal> variables = [];
  var box = GetStorage();
  var date = DateTime.now();
  var testDataModal = TestDataModal().obs;
  var orderByOrder = "";
  var orderByName = "";
  var orderByStatus = "";
  var orderByDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVariables();
    fetchOrderList();
  }

  void recordOrderBy(String name) {
    if (name == "orderByOrder") {
      if (orderByOrder.isEmpty) {
        orderByOrder = "up";
        testDataModal.value.orderList!.sort(
            (a, b) => (int.parse(a.orderNo!).compareTo(int.parse(b.orderNo!))));
      } else {
        if (orderByOrder == "up") {
          orderByOrder = "down";
          testDataModal.value.orderList!.sort((a, b) =>
              (int.parse(b.orderNo!).compareTo(int.parse(a.orderNo!))));
        } else {
          orderByOrder = "up";
          testDataModal.value.orderList!.sort((a, b) =>
              (int.parse(a.orderNo!).compareTo(int.parse(b.orderNo!))));
        }
      }
      orderByName = "";
      orderByStatus = "";
      orderByDate = "";
    }
    if (name == "orderByName") {
      if (orderByName.isEmpty) {
        orderByName = "up";
        testDataModal.value.orderList!
            .sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        if (orderByName == "up") {
          orderByName = "down";
          testDataModal.value.orderList!
              .sort((a, b) => b.name!.compareTo(a.name!));
        } else {
          orderByName = "up";
          testDataModal.value.orderList!
              .sort((a, b) => a.name!.compareTo(b.name!));
        }
      }
      orderByOrder = "";
      orderByStatus = "";
      orderByDate = "";
    }
    if (name == "orderByStatus") {
      if (orderByStatus.isEmpty) {
        orderByStatus = "up";
        testDataModal.value.orderList!
            .sort((a, b) => a.status!.compareTo(b.status!));
      } else {
        if (orderByStatus == "up") {
          orderByStatus = "down";
          testDataModal.value.orderList!
              .sort((a, b) => b.status!.compareTo(a.status!));
        } else {
          orderByStatus = "up";
          testDataModal.value.orderList!
              .sort((a, b) => a.status!.compareTo(b.status!));
        }
      }
      orderByOrder = "";
      orderByDate = "";
      orderByName = "";
    }
    if (name == "orderByDate") {
      if (orderByDate.isEmpty) {
        orderByDate = "up";
        testDataModal.value.orderList!
            .sort((a, b) => a.createdOn!.compareTo(b.createdOn!));
      } else {
        if (orderByDate == "up") {
          orderByDate = "down";
          testDataModal.value.orderList!
              .sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
        } else {
          orderByDate = "up";
          testDataModal.value.orderList!
              .sort((a, b) => a.createdOn!.compareTo(b.createdOn!));
        }
      }
      orderByOrder = "";
      orderByName = "";
      orderByStatus = "";
    }
    setState(() {});
  }

  fetchVariables({bool move = false}) {
    DashboardService.fetchResultVariable().then((value) {
      if (value != null) {
        variables = value;
      }
    });
  }

  void fetchOrderList() {
    //widget.date??null, widget.labid??"", widget.status!, widget.upcomingTodayHistory??"", limit, offset.value
    DashboardService.fetchOrders(
      limit: 40,
      offset: 0,
      labId: box.read(StorageConstant.id),
      orderBy: "desc",
    ).then((value) {
      if (value != null) {
        testDataModal.value = value;
      }
    });
  }

  fetchUserDetail(String orderNo) {
    print("Result Barcode order no $orderNo");
    Get.defaultDialog(title: "Please Wait...", middleText: "Order is Fetching");

    DashboardService.fetchUserDetailByOrderNo(orderNo: orderNo)
        .then((userOrderDetailModal) {
      if (userOrderDetailModal != null) {
        if (userOrderDetailModal.status!) {
          if (Get.isDialogOpen!) {
            Get.back();
          }
          Get.to(LabSubmitTestResult(
            userOrderDetailModal: userOrderDetailModal,
            variables: variables,
          ));
        } else {
          if (Get.isDialogOpen!) {
            Get.back();
          }
          Get.defaultDialog(title: "Alert", middleText: "No Record Found");
        }
      } else {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Get.snackbar("Error", "Something went wrong");
      }
      if (Get.isDialogOpen!) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appname),
        actions: [
          SizedBox(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  box.erase();
                  Get.offAll(LoginPage());
                },
                child: Icon(Icons.logout),
              ),
            ),
          ),
          gapWidthL2,
          SizedBox(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  fetchOrderList();
                },
                child: Icon(Icons.refresh),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              color: myWhite,
              child: Image.asset(
                "assets/images/lab.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  child: ElevatedButton(
                      onPressed: () async {
                        var result = await BarcodeScanner.scan();
                        print("Result Barcode ${result.rawContent}");
                        fetchUserDetail(result.rawContent);
                      },
                      child: const Text("Scan Barcode")),
                ),
                SizedBox(
                    width: Get.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(LabTestList(
                            title: "My Pending",
                            status: "pending",
                          ));
                        },
                        child: Text("My Pending"))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: Get.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(LabTestList(
                            title: "Today",
                            status: "pending",
                            date: DateFormat("yyyy-MM-dd").format(date),
                            upcomingTodayHistory: StorageConstant.today,
                          ));
                        },
                        child: Text("Today Test"))),
                SizedBox(
                    width: Get.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(
                            LabTestList(
                                title: "Upcoming",
                                date: DateFormat("yyyy-MM-dd").format(date),
                                status: "pending",
                                upcomingTodayHistory: StorageConstant.upcoming),
                          );
                        },
                        child: const Text("Upcoming Test")))
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "Recents Tests",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    Obx(
                      () => testDataModal.value.orderList != null &&
                              testDataModal.value.orderList!.isNotEmpty
                          ? Table(
                              border:
                                  TableBorder.all(color: Colors.grey.shade200),
                              children: [
                                TableRow(children: [
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () {
                                      recordOrderBy("orderByOrder");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Order No",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            orderByOrder.isNotEmpty
                                                ? Icon(
                                                    orderByOrder == "up"
                                                        ? Icons
                                                            .keyboard_arrow_down_outlined
                                                        : Icons
                                                            .keyboard_arrow_up_outlined,
                                                    size: 16,
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () {
                                      recordOrderBy("orderByName");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Name",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            orderByName.isNotEmpty
                                                ? Icon(
                                                    orderByName == "up"
                                                        ? Icons
                                                            .keyboard_arrow_down_outlined
                                                        : Icons
                                                            .keyboard_arrow_up_outlined,
                                                    size: 16,
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () {
                                      recordOrderBy("orderByStatus");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Status",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            orderByStatus.isNotEmpty
                                                ? Icon(
                                                    orderByStatus == "up"
                                                        ? Icons
                                                            .keyboard_arrow_down_outlined
                                                        : Icons
                                                            .keyboard_arrow_up_outlined,
                                                    size: 14,
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () {
                                      recordOrderBy("orderByDate");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Date",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            orderByDate.isNotEmpty
                                                ? Icon(
                                                    orderByDate == "up"
                                                        ? Icons
                                                            .keyboard_arrow_down_outlined
                                                        : Icons
                                                            .keyboard_arrow_up_outlined,
                                                    size: 14,
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Center(child: Text("View"))),
                                ]),
                                ...testDataModal.value.orderList!.map((e) {
                                  return TableRow(children: [
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Center(child: Text(e.orderNo!))),
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Center(
                                            child: Text(
                                          e.name!,
                                          style: TextStyle(fontSize: 11),
                                        ))),
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Center(
                                          child: Text(e.status!,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: e.status! == 'completed'
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                        )),
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Center(
                                            child: Text(
                                          "${e.createdOn}",
                                          style: TextStyle(fontSize: 11),
                                        ))),
                                    TableCell(
                                        child: TextButton(
                                      onPressed: () {
                                        fetchUserDetail(e.orderNo!);
                                      },
                                      child: e.status! == 'cancelled'
                                          ? SizedBox.shrink()
                                          : Text("View"),
                                    )),
                                  ]);
                                }).toList()
                              ],
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
