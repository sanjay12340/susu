// To parse this JSON data, do
//
//     final userOrderDetailModal = userOrderDetailModalFromJson(jsonString);

import 'dart:convert';

UserOrderDetailModal userOrderDetailModalFromJson(String str) =>
    UserOrderDetailModal.fromJson(json.decode(str));

String userOrderDetailModalToJson(UserOrderDetailModal data) =>
    json.encode(data.toJson());

class UserOrderDetailModal {
  final bool? status;
  final User? user;
  final OrderDetail? orderDetail;
  final List<OrderReport>? orderReport;

  UserOrderDetailModal({
    this.status,
    this.user,
    this.orderDetail,
    this.orderReport,
  });

  factory UserOrderDetailModal.fromJson(Map<String, dynamic> json) =>
      UserOrderDetailModal(
        status: json["status"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        orderDetail: json["order_detail"] == null
            ? null
            : OrderDetail.fromJson(json["order_detail"]),
        orderReport: json["order_report"] == null
            ? []
            : List<OrderReport>.from(
                json["order_report"]!.map((x) => OrderReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user?.toJson(),
        "order_detail": orderDetail?.toJson(),
        "order_report": orderReport == null
            ? []
            : List<dynamic>.from(orderReport!.map((x) => x.toJson())),
      };
}

class OrderDetail {
  final String? id;
  final String? orderNo;
  final String? userId;
  final String? labId;
  final String? testId;
  final String? testName;
  final String? testFee;
  final String? status;
  final String? locked;
  final String? remarks;
  final dynamic cancelled;
  final dynamic cancelledBy;
  final dynamic cancelledOn;
  final dynamic cancelledRemark;
  final String? createdBy;
  final DateTime? createdOn;
  final DateTime? scheduledPicktimeStart;
  final dynamic scheduledPicktimeEnd;
  final String? userAddressId;
  final String? userPhone;
  final dynamic addressType;

  OrderDetail({
    this.id,
    this.orderNo,
    this.userId,
    this.labId,
    this.testId,
    this.testName,
    this.testFee,
    this.status,
    this.locked,
    this.remarks,
    this.cancelled,
    this.cancelledBy,
    this.cancelledOn,
    this.cancelledRemark,
    this.createdBy,
    this.createdOn,
    this.scheduledPicktimeStart,
    this.scheduledPicktimeEnd,
    this.userAddressId,
    this.userPhone,
    this.addressType,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderNo: json["order_no"],
        userId: json["user_id"],
        labId: json["lab_id"],
        testId: json["test_id"],
        testName: json["test_name"],
        testFee: json["test_fee"],
        status: json["status"],
        locked: json["locked"],
        remarks: json["remarks"],
        cancelled: json["cancelled"],
        cancelledBy: json["cancelled_by"],
        cancelledOn: json["cancelled_on"],
        cancelledRemark: json["cancelled_remark"],
        createdBy: json["created_by"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        scheduledPicktimeStart: json["scheduled_picktime_start"] == null
            ? null
            : DateTime.parse(json["scheduled_picktime_start"]),
        scheduledPicktimeEnd: json["scheduled_picktime_end"],
        userAddressId: json["user_address_id"],
        userPhone: json["user_phone"],
        addressType: json["address_type"],
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
        "locked": locked,
        "remarks": remarks,
        "cancelled": cancelled,
        "cancelled_by": cancelledBy,
        "cancelled_on": cancelledOn,
        "cancelled_remark": cancelledRemark,
        "created_by": createdBy,
        "created_on": createdOn?.toIso8601String(),
        "scheduled_picktime_start": scheduledPicktimeStart?.toIso8601String(),
        "scheduled_picktime_end": scheduledPicktimeEnd,
        "user_address_id": userAddressId,
        "user_phone": userPhone,
        "address_type": addressType,
      };
}

class OrderReport {
  final String? id;
  final String? orderId;
  final String? variableId;
  final String? name;
  final String? fname;

  final String? value;
  final DateTime? createAt;
  final String? alise;
  final String? pCondition;
  final String? dimention;

  OrderReport({
    this.id,
    this.orderId,
    this.variableId,
    this.fname,
    this.name,
    this.value,
    this.createAt,
    this.alise,
    this.pCondition,
    this.dimention,
  });

  factory OrderReport.fromJson(Map<String, dynamic> json) => OrderReport(
        id: json["id"],
        orderId: json["order_id"],
        variableId: json["variable_id"],
        name: json["name"],
        fname: json["fname"],
        value: json["value"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        alise: json["alise"],
        pCondition: json["p_condition"],
        dimention: json["dimention"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "variable_id": variableId,
        "name": name,
        "value": value,
        "create_at": createAt?.toIso8601String(),
        "alise": alise,
        "p_condition": pCondition,
        "dimention": dimention,
      };
}

class User {
  final String? id;
  final String? username;
  final String? password;
  final String? name;
  final DateTime? dob;
  final String? sex;
  final String? height;
  final String? weight;
  final String? email;
  final String? labName;
  final String? settings;
  final String? bodyType;
  final String? diet;
  final String? allergy;
  final String? phone;
  final String? userType;
  final String? deviceToken;
  final String? loginToken;
  final dynamic otp;
  final String? otpStatus;
  final String? point;
  final DateTime? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.username,
    this.password,
    this.name,
    this.dob,
    this.sex,
    this.height,
    this.weight,
    this.email,
    this.labName,
    this.settings,
    this.bodyType,
    this.diet,
    this.allergy,
    this.phone,
    this.userType,
    this.deviceToken,
    this.loginToken,
    this.otp,
    this.otpStatus,
    this.point,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        sex: json["sex"],
        height: json["height"],
        weight: json["weight"],
        email: json["email"],
        labName: json["lab_name"],
        settings: json["settings"],
        bodyType: json["body_type"],
        diet: json["diet"],
        allergy: json["allergy"],
        phone: json["phone"],
        userType: json["user_type"],
        deviceToken: json["device_token"],
        loginToken: json["login_token"],
        otp: json["otp"],
        otpStatus: json["otp_status"],
        point: json["point"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "name": name,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "sex": sex,
        "height": height,
        "weight": weight,
        "email": email,
        "lab_name": labName,
        "settings": settings,
        "body_type": bodyType,
        "diet": diet,
        "allergy": allergy,
        "phone": phone,
        "user_type": userType,
        "device_token": deviceToken,
        "login_token": loginToken,
        "otp": otp,
        "otp_status": otpStatus,
        "point": point,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
