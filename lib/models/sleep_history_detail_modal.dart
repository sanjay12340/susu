// To parse this JSON data, do
//
//     final sleepHistoryDetailModal = sleepHistoryDetailModalFromJson(jsonString);

import 'dart:convert';

SleepHistoryDetailModal sleepHistoryDetailModalFromJson(String str) =>
    SleepHistoryDetailModal.fromJson(json.decode(str));

String sleepHistoryDetailModalToJson(SleepHistoryDetailModal data) =>
    json.encode(data.toJson());

class SleepHistoryDetailModal {
  final bool? status;
  final Today? today;
  final List<Today>? history;

  SleepHistoryDetailModal({
    this.status,
    this.today,
    this.history,
  });

  factory SleepHistoryDetailModal.fromJson(Map<String, dynamic> json) =>
      SleepHistoryDetailModal(
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
  final String? start;
  final String? end;
  final String? duration;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Today({
    this.id,
    this.userId,
    this.goal,
    this.start,
    this.end,
    this.duration,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Today.fromJson(Map<String, dynamic> json) => Today(
        id: json["id"],
        userId: json["user_id"],
        goal: json["goal"],
        start: json["start"],
        end: json["end"],
        duration: json["duration"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "goal": goal,
        "start": start,
        "end": end,
        "duration": duration,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
