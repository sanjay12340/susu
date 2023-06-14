// To parse this JSON data, do
//
//     final waterTakenTodayModal = waterTakenTodayModalFromJson(jsonString);

import 'dart:convert';

WaterTakenTodayModal waterTakenTodayModalFromJson(String str) =>
    WaterTakenTodayModal.fromJson(json.decode(str));

String waterTakenTodayModalToJson(WaterTakenTodayModal data) =>
    json.encode(data.toJson());

class WaterTakenTodayModal {
  final bool? status;
  final List<Today>? today;
  final String? goal;

  WaterTakenTodayModal({
    this.status,
    this.today,
    this.goal,
  });

  factory WaterTakenTodayModal.fromJson(Map<String, dynamic> json) =>
      WaterTakenTodayModal(
        status: json["status"],
        today: json["today"] == null
            ? []
            : List<Today>.from(json["today"]!.map((x) => Today.fromJson(x))),
        goal: json["goal"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "today": today == null
            ? []
            : List<dynamic>.from(today!.map((x) => x.toJson())),
        "goal": goal,
      };
}

class Today {
  final String? glass;
  final String? goal;
  final DateTime? date;
  final DateTime? createdAt;

  Today({
    this.glass,
    this.goal,
    this.date,
    this.createdAt,
  });

  factory Today.fromJson(Map<String, dynamic> json) => Today(
        glass: json["glass"],
        goal: json["goal"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "glass": glass,
        "goal": goal,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
      };
}
