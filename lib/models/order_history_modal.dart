// To parse this JSON data, do
//
//     final orderHistoryPage = orderHistoryPageFromJson(jsonString);

import 'dart:convert';

OrderHistoryPage orderHistoryPageFromJson(String str) =>
    OrderHistoryPage.fromJson(json.decode(str));

String orderHistoryPageToJson(OrderHistoryPage data) =>
    json.encode(data.toJson());

class OrderHistoryPage {
  final bool? status;
  final List<OrderList>? orderList;
  final String? count;

  OrderHistoryPage({
    this.status,
    this.orderList,
    this.count,
  });

  factory OrderHistoryPage.fromJson(Map<String, dynamic> json) =>
      OrderHistoryPage(
        status: json["status"],
        orderList: json["order_list"] == null
            ? []
            : List<OrderList>.from(
                json["order_list"]!.map((x) => OrderList.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_list": orderList == null
            ? []
            : List<dynamic>.from(orderList!.map((x) => x.toJson())),
        "count": count,
      };
}

class OrderList {
  final String? id;
  final String? orderNo;
  final String? userId;
  final String? labId;
  final String? testId;
  final String? testName;
  final bool? locked;
  final String? testFee;
  final String? status;
  final String? remarks;
  final DateTime? createdOn;
  final DateTime? scheduledPicktimeStart;

  OrderList({
    this.id,
    this.orderNo,
    this.userId,
    this.labId,
    this.testId,
    this.locked,
    this.testName,
    this.testFee,
    this.status,
    this.remarks,
    this.createdOn,
    this.scheduledPicktimeStart,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        id: json["id"],
        orderNo: json["order_no"],
        userId: json["user_id"],
        labId: json["lab_id"],
        testId: json["test_id"],
        testName: json["test_name"],
        locked: json["locked"] == null || json["locked"] == "1" ? true : false,
        testFee: json["test_fee"],
        status: json["status"],
        remarks: json["remarks"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        scheduledPicktimeStart: json["scheduled_picktime_start"] == null
            ? null
            : DateTime.parse(json["scheduled_picktime_start"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "user_id": userId,
        "lab_id": labId,
        "test_id": testId,
        "test_name": testName,
        "test_fee": testFee,
        "status": status,
        "remarks": remarks,
        "created_on": createdOn?.toIso8601String(),
        "scheduled_picktime_start": scheduledPicktimeStart?.toIso8601String(),
      };
}
