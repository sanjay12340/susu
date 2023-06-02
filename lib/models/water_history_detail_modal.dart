// To parse this JSON data, do
//
//     final waterHistoryDetailModal = waterHistoryDetailModalFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

WaterHistoryDetailModal waterHistoryDetailModalFromJson(String str) =>
    WaterHistoryDetailModal.fromJson(json.decode(str));

String waterHistoryDetailModalToJson(WaterHistoryDetailModal data) =>
    json.encode(data.toJson());

class WaterHistoryDetailModal {
  final bool? status;
  final Today? today;
  final List<Today>? history;

  WaterHistoryDetailModal({
    this.status,
    this.today,
    this.history,
  });

  factory WaterHistoryDetailModal.fromJson(Map<String, dynamic> json) =>
      WaterHistoryDetailModal(
        status: json["status"],
        today: json["today"] == null ? null : Today.fromJson(json["today"]),
        history: json["history"] == null
            ? []
            : List<Today>.from(json["history"]!.map((x) => Today.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "today": today?.toJson(),
        "history": history == null
            ? []
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class Today {
  final String? id;
  final String? userId;
  final String? goal;
  final String? glass;
  final DateTime? lastOrderDate;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Today({
    this.id,
    this.userId,
    this.goal,
    this.glass,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.lastOrderDate,
  });

  factory Today.fromJson(Map<String, dynamic> json) => Today(
        id: json["id"],
        userId: json["user_id"],
        goal: json["goal"],
        glass: json["glass"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        lastOrderDate: json["last_order_date"] == null
            ? null
            : DateFormat("dd-MM-yyyy").parse(json["last_order_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "goal": goal,
        "glass": glass,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
