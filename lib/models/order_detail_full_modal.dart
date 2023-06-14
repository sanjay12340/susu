// To parse this JSON data, do
//
//     final orderDetailFullModal = orderDetailFullModalFromJson(jsonString);

import 'dart:convert';

OrderDetailFullModal orderDetailFullModalFromJson(String str) =>
    OrderDetailFullModal.fromJson(json.decode(str));

String orderDetailFullModalToJson(OrderDetailFullModal data) =>
    json.encode(data.toJson());

class OrderDetailFullModal {
  final bool? status;
  final String? msg;
  final OrderDetail? orderDetail;
  final List<ReportDetail>? reportDetail;

  OrderDetailFullModal(
      {this.status, this.orderDetail, this.reportDetail, this.msg});

  factory OrderDetailFullModal.fromJson(Map<String, dynamic> json) =>
      OrderDetailFullModal(
        status: json["status"],
        msg: json["msg"],
        orderDetail: json["order_detail"] == null
            ? null
            : OrderDetail.fromJson(json["order_detail"]),
        reportDetail: json["report_detail"] == null
            ? []
            : List<ReportDetail>.from(
                json["report_detail"]!.map((x) => ReportDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_detail": orderDetail?.toJson(),
        "report_detail": reportDetail == null
            ? []
            : List<dynamic>.from(reportDetail!.map((x) => x.toJson())),
      };
}

class OrderDetail {
  final String? id;
  final String? orderNo;
  final String? bmi;
  final String? testName;
  final String? locked;
  final String? status;
  final DateTime? scheduledPicktimeStart;

  OrderDetail({
    this.id,
    this.orderNo,
    this.testName,
    this.locked,
    this.bmi,
    this.status,
    this.scheduledPicktimeStart,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderNo: json["order_no"],
        testName: json["test_name"],
        locked: json["locked"],
        status: json["status"],
        bmi: json["bmi"],
        scheduledPicktimeStart: json["scheduled_picktime_start"] == null
            ? null
            : DateTime.parse(json["scheduled_picktime_start"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "test_name": testName,
        "scheduled_picktime_start": scheduledPicktimeStart?.toIso8601String(),
      };
}

class ReportDetail {
  final String? id;
  final String? orderId;
  final String? variableId;
  final String? name;
  final String? fname;
  final String? value;
  final DateTime? createAt;
  final String? alias;
  final String? condtion;

  ReportDetail({
    this.id,
    this.orderId,
    this.variableId,
    this.name,
    this.fname,
    this.value,
    this.createAt,
    this.alias,
    this.condtion,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) => ReportDetail(
        id: json["id"],
        orderId: json["order_id"],
        variableId: json["variable_id"],
        name: json["name"],
        fname: json["fname"],
        value: json["value"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        alias: json["alias"],
        condtion: json["p_condition"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "variable_id": variableId,
        "name": name,
        "fname": fname,
        "value": value,
        "create_at": createAt?.toIso8601String(),
        "alias": alias,
        "p_condition": condtion,
      };
}
