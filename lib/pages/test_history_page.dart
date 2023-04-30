import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/pages/report_detail_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/storage_constant.dart';

import '../models/order_history_modal.dart';
import 'package:intl/intl.dart';

class TestHistoryPage extends StatefulWidget {
  const TestHistoryPage({Key? key}) : super(key: key);
  @override
  _TestHistoryPageState createState() => _TestHistoryPageState();
}

class _TestHistoryPageState extends State<TestHistoryPage> {
  List<String> rules = [
    "On every refer get 10 point",
    "These point use to unlock your report detail"
  ];
  final int limit = 20;
  final int offset = 0;
  int point = 10;
  double iconSize = 45;
  OrderHistoryPage? _orderHistoryPage;
  Widget boxSize = const SizedBox(
    width: 20,
  );
  var box = GetStorage();
  @override
  initState() {
    super.initState();

    fetchOrders();
    print(box.toString());
  }

  fetchOrders() {
    DashboardService.fetchOrderHistory(
            userId: box.read(StorageConstant.id),
            limit: limit,
            offset: limit * offset)
        .then((value) {
      if (value != null) {
        print(value.toJson());
        if (value.orderList != null) {
          List<OrderList>? orderList = value.orderList;
          if (orderList != null) {
            for (var element in orderList) {
              reportDetail.add(
                ReportDetail(
                    testDate: DateFormat("dd-MM-yyyy")
                        .format(element.scheduledPicktimeStart!),
                    id: element.id,
                    locked: element.locked,
                    name: box.read(StorageConstant.name),
                    orderNo: element.orderNo,
                    status: element.status),
              );
              setState(() {});
            }
          }
        }
      }
    });
  }

  List<ReportDetail> reportDetail = [];
  void setRecord() {
    for (var i = 0; i < 20; i++) {
      reportDetail.add(ReportDetail(
          id: "${i + 1}",
          locked: true,
          shared: intToBool(Random().nextInt(100)),
          testDate: "$i-02-2023"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent History"),
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: "Info",
                    content: Column(
                        children: List.generate(
                            rules.length,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${index + 1}.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(child: Text(rules[index]))
                                    ],
                                  ),
                                ))));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: SingleChildScrollView(
        child: reportDetail.length > 0
            ? Column(
                children: [
                  Column(
                    children: reportDetail.map((val) {
                      val.locked;
                      String statusButtonText = '';
                      switch (val.status) {
                        case 'pending':
                          statusButtonText = "Pending";
                          break;
                        case 'captured':
                          statusButtonText = "Pending";
                          break;
                        case 'cancelled':
                          statusButtonText = "cancelled";
                          break;
                        default:
                          statusButtonText = "";
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Report : ${val.orderNo}"),
                                    Text("Date : ${val.testDate!}")
                                  ],
                                ),
                                Row(
                                  children: [Text("Name : ${val.name}")],
                                ),
                                //'pending','captured','completed','cancelled'
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    val.status == "pending" ||
                                            val.status == "captured" ||
                                            val.status == "cancelled"
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .orange.shade400,
                                                textStyle: TextStyle(
                                                    color: Colors.black)),
                                            onPressed: () {},
                                            child: Text(
                                              statusButtonText,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))
                                        : !val.locked!
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  Get.to(ReportDetailPage(
                                                      reportId: val.id));
                                                },
                                                child: Text("View Report"))
                                            : int.parse(box.read(StorageConstant
                                                            .point) ??
                                                        "0") >=
                                                    10
                                                ? ElevatedButton(
                                                    onPressed: () {
                                                      DashboardService
                                                              .openReportConsumePoints(
                                                                  points: 10,
                                                                  type:
                                                                      "consume",
                                                                  orderID: val
                                                                      .id!
                                                                      .toString())
                                                          .then((value) {
                                                        setState(() {
                                                          if (value != null &&
                                                              value['status']) {
                                                            box.write(
                                                                StorageConstant
                                                                    .point,
                                                                value[
                                                                    'points']);
                                                            val.locked = false;
                                                          } else {}
                                                        });
                                                      });
                                                    },
                                                    child: Text(
                                                        "Unlock 10 points"))
                                                : ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                        title: "Share",
                                                        onConfirm: () {},
                                                        content: Column(
                                                          children: [
                                                            const Text(
                                                              "By share you can unlock your report",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Wrap(
                                                                children: [
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .whatsappSquare,
                                                                    color: Colors
                                                                        .green,
                                                                    size:
                                                                        iconSize,
                                                                  ),
                                                                  boxSize,
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .facebookSquare,
                                                                    size:
                                                                        iconSize,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  boxSize,
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .instagramSquare,
                                                                    size:
                                                                        iconSize,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  boxSize,
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .share,
                                                                    size:
                                                                        iconSize,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                        "UnLock Reort"))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }

  bool intToBool(int a) {
    return (a % 2) == 0;
  }
}

class ReportDetail {
  ReportDetail({
    this.orderNo,
    this.testDate,
    this.shared,
    this.id,
    this.locked,
    this.status,
    this.name,
  });
  String? testDate;
  bool? shared;
  String? id;
  String? orderNo;
  bool? locked;
  String? status;
  String? name;
}
