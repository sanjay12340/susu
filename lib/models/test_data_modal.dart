// To parse this JSON data, do
//
//     final testDataModal = testDataModalFromJson(jsonString);

import 'dart:convert';

TestDataModal testDataModalFromJson(String str) =>
    TestDataModal.fromJson(json.decode(str));

String testDataModalToJson(TestDataModal data) => json.encode(data.toJson());

class TestDataModal {
  final bool? status;
  final String? orderCount;
  final List<OrderList>? orderList;

  TestDataModal({
    this.status,
    this.orderCount,
    this.orderList,
  });

  factory TestDataModal.fromJson(Map<String, dynamic> json) => TestDataModal(
        status: json["status"],
        orderCount: json["order_count"],
        orderList: json["order_list"] == null
            ? []
            : List<OrderList>.from(
                json["order_list"]!.map((x) => OrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_count": orderCount,
        "order_list": orderList == null
            ? []
            : List<dynamic>.from(orderList!.map((x) => x.toJson())),
      };
}

class OrderList {
  final String? orderId;
  final String? orderNo;
  final String? testName;
  final String? testFee;
  final String? status;
  final String? locked;
  final DateTime? createdOn;
  final DateTime? scheduledPicktimeStart;
  final DateTime? scheduledPicktimeEnd;
  final String? userPhone;
  final String? username;
  final String? name;
  final String? sex;
  final DateTime? dob;
  final String? weight;
  final String? phone;
  final String? labName;
  final String? labUserName;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pin;
  final String? phone1;
  final String? phone2;
  final String? labAddress;
  final String? labCity;

  OrderList( {
    this.orderId,
    this.orderNo,
    this.testName,
    this.testFee,
    this.status,
    this.locked,
    this.createdOn,
    this.scheduledPicktimeStart,
    this.scheduledPicktimeEnd,
    this.userPhone,
    this.username,
    this.name,
    this.sex,
    this.weight,
    this.phone,
    this.labName,
    this.labUserName,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pin,
    this.phone1,
    this.phone2,
    this.labAddress,
    this.labCity,
    this.dob,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        orderId: json["order_id"],
        orderNo: json["order_no"],
        testName: json["test_name"],
        testFee: json["test_fee"],
        status: json["status"],
        locked: json["locked"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        scheduledPicktimeStart: json["scheduled_picktime_start"] == null
            ? null
            : DateTime.parse(json["scheduled_picktime_start"]),
        scheduledPicktimeEnd: json["scheduled_picktime_end"] == null
            ? null
            : DateTime.parse(json["scheduled_picktime_end"]),
        userPhone: json["user_phone"],
        username: json["username"],
        name: json["name"],
        sex: json["sex"],
        weight: json["weight"],
        phone: json["phone"],
        labName: json["lab_name"],
        labUserName: json["lab_user_name"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pin: json["pin"],
        phone1: json["phone1"],
        phone2: json["phone2"],
        labAddress: json["lab_address"],
        labCity: json["lab_city"],
        dob: json["dob"] == null
            ? null
            : DateTime.parse(json["dob"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_no": orderNo,
        "test_name": testName,
        "test_fee": testFee,
        "status": status,
        "locked": locked,
        "created_on": createdOn?.toIso8601String(),
        "scheduled_picktime_start": scheduledPicktimeStart?.toIso8601String(),
        "scheduled_picktime_end": scheduledPicktimeEnd?.toIso8601String(),
        "user_phone": userPhone,
        "username": username,
        "name": name,
        "sex": sex,
        "weight": weight,
        "phone": phone,
        "lab_name": labName,
        "lab_user_name": labUserName,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pin": pin,
        "phone1": phone1,
        "phone2": phone2,
        "lab_address": labAddress,
        "lab_city": labCity,
        "dob": dob?.toIso8601String(),
      };
}
