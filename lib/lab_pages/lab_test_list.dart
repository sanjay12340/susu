import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:susu/services/dashboard_service.dart';

import '../models/test_data_modal.dart';
import 'package:intl/intl.dart';

class LabTestList extends StatefulWidget {
  final String title;
  final String? upcomingTodayHistory;
  final String? labid;
  final String? status;
  final String? date;

  const LabTestList(
      {Key? key,
      required this.title,
      this.upcomingTodayHistory,
      this.labid,
      this.status,
      this.date})
      : super(key: key);

  @override
  _LabTestListState createState() => _LabTestListState();
}

class _LabTestListState extends State<LabTestList> {
  var testDataModal = TestDataModal().obs;
  var limit = 10;
  var offset = 0.obs;
  var totalRecord = 0.obs;
  var waiting = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrderList();
  }

  void fetchOrderList() {
    //widget.date??null, widget.labid??"", widget.status!, widget.upcomingTodayHistory??"", limit, offset.value
    DashboardService.fetchOrders(
      limit: limit,
      offset: offset.value,
      status: widget.status,
      date: widget.date,
      upcomingTodayHistory: widget.upcomingTodayHistory,
    ).then((value) {
      if (value != null) {
        testDataModal.value = value;
        if (offset.value == 0) {
          totalRecord.value = int.parse(value.orderCount ?? "0");
          if (totalRecord < limit) {
            totalRecord.value = limit;
          }
        }
      }

      waiting.value = false;
    });
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    print("Age $age");
    return age;
  }

  void captureTest(String orderId) {
    DashboardService.catpturTest(orderId).then((value) {
      if (value != null) {
        if (value['status']) {
          waiting.value = true;
          fetchOrderList();
        } else {
          Get.defaultDialog(
              title: "Alert", middleText: value['msg'] ?? "Captured");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomSheet: Obx(
        () => Container(
          child: Row(children: [
            ElevatedButton(
                onPressed: () {
                  if (offset.value > 0 && !waiting.value) {
                    waiting.value = true;
                    offset.value--;
                    fetchOrderList();
                  }
                },
                child: Text("Prev")),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Page : ${offset.value + 1}/${(totalRecord / limit).round()}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            )),
            ElevatedButton(
                onPressed: () {
                  if ((totalRecord / limit).round() > (offset.value + 1) &&
                      !waiting.value) {
                    waiting.value = true;
                    offset.value++;
                    fetchOrderList();
                  }
                },
                child: Text("Next")),
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text("Today Date : ${widget.date ?? ''}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Obx(
              () => waiting.value
                  ? CircularProgressIndicator()
                  : testDataModal.value.orderList != null &&
                          testDataModal.value.orderList!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: testDataModal.value.orderList!.map((e) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Order No : ${e.orderNo}"),
                                                Text(
                                                    "Date ${DateFormat("dd-MM-yyyy").format(e.scheduledPicktimeStart!)}")
                                              ],
                                            ),
                                            SizedBox(
                                              child: BarcodeWidget(
                                                height: 40,
                                                width: 100,
                                                barcode: Barcode.code128(),
                                                data: e.orderNo!,
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Name: ${e.name}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "Age: ${calculateAge(e.dob!)}",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Gender: ${e.sex}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address : ",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                    " ${e.address!} ${e.city!}, ${e.state} ",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Phone : ",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Column(
                                              children: [
                                                Text(" ${e.phone1} ",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Status : ",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Column(
                                              children: [
                                                Text(" ${e.status} ",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        e.status != null &&
                                                e.status == "pending"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: widget.title ==
                                                              "My Pending"
                                                          ? () {}
                                                          : () {
                                                              captureTest(
                                                                  e.orderId!);
                                                            },
                                                      child: Text(
                                                          widget.title ==
                                                                  "My Pending"
                                                              ? "Captured"
                                                              : "Capture"))
                                                ],
                                              )
                                            : SizedBox.shrink()
                                      ]),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : Text("No Record Found"),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
