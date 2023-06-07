// To parse this JSON data, do
//
//     final stepHistoryDetailModal = stepHistoryDetailModalFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

StepHistoryDetailModal stepHistoryDetailModalFromJson(String str) =>
    StepHistoryDetailModal.fromJson(json.decode(str));

String stepHistoryDetailModalToJson(StepHistoryDetailModal data) =>
    json.encode(data.toJson());

class StepHistoryDetailModal {
  final bool? status;
  final Today? today;
  final List<Today>? history;

  StepHistoryDetailModal({
    this.status,
    this.today,
    this.history,
  });

  factory StepHistoryDetailModal.fromJson(Map<String, dynamic> json) =>
      StepHistoryDetailModal(
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
  final String? steps;
  final String? calorie;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastOrderDate;

  Today({
    this.id,
    this.userId,
    this.goal,
    this.steps,
    this.calorie,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.lastOrderDate,
  });

  factory Today.fromJson(Map<String, dynamic> json) => Today(
        id: json["id"] ?? "",
        userId: json["user_id"] ?? "",
        goal: json["goal"] != null ? json["goal"].toString() : null,
        steps: json["steps"] != null ? json["steps"].toString() : null,
        calorie: json["calorie"] != null ? json["calorie"].toString() : null,
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
        "steps": steps,
        "calorie": calorie,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
