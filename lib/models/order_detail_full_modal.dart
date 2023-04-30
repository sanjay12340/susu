// To parse this JSON data, do
//
//     final orderDetailFullModal = orderDetailFullModalFromJson(jsonString);

import 'dart:convert';

OrderDetailFullModal orderDetailFullModalFromJson(String str) => OrderDetailFullModal.fromJson(json.decode(str));

String orderDetailFullModalToJson(OrderDetailFullModal data) => json.encode(data.toJson());

class OrderDetailFullModal {
    final bool? status;
    final OrderDetail? orderDetail;
    final List<ReportDetail>? reportDetail;

    OrderDetailFullModal({
        this.status,
        this.orderDetail,
        this.reportDetail,
    });

    factory OrderDetailFullModal.fromJson(Map<String, dynamic> json) => OrderDetailFullModal(
        status: json["status"],
        orderDetail: json["order_detail"] == null ? null : OrderDetail.fromJson(json["order_detail"]),
        reportDetail: json["report_detail"] == null ? [] : List<ReportDetail>.from(json["report_detail"]!.map((x) => ReportDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "order_detail": orderDetail?.toJson(),
        "report_detail": reportDetail == null ? [] : List<dynamic>.from(reportDetail!.map((x) => x.toJson())),
    };
}

class OrderDetail {
    final String? id;
    final String? orderNo;
    final String? testName;
    final DateTime? scheduledPicktimeStart;

    OrderDetail({
        this.id,
        this.orderNo,
        this.testName,
        this.scheduledPicktimeStart,
    });

    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderNo: json["order_no"],
        testName: json["test_name"],
        scheduledPicktimeStart: json["scheduled_picktime_start"] == null ? null : DateTime.parse(json["scheduled_picktime_start"]),
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
    final String? value;
    final DateTime? createAt;
    final String? alise;

    ReportDetail({
        this.id,
        this.orderId,
        this.variableId,
        this.name,
        this.value,
        this.createAt,
        this.alise,
    });

    factory ReportDetail.fromJson(Map<String, dynamic> json) => ReportDetail(
        id: json["id"],
        orderId: json["order_id"],
        variableId: json["variable_id"],
        name: json["name"],
        value: json["value"],
        createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
        alise: json["alise"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "variable_id": variableId,
        "name": name,
        "value": value,
        "create_at": createAt?.toIso8601String(),
        "alise": alise,
    };
}
