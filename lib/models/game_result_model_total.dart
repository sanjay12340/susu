// To parse this JSON data, do
//
//     final gameResultModelTotal = gameResultModelTotalFromJson(jsonString);

import 'dart:convert';

import 'package:susu/models/game_result_model.dart';
import 'package:susu/models/last_result.dart';

GameResultModelTotal gameResultModelTotalFromJson(String str) =>
    GameResultModelTotal.fromJson(json.decode(str));

String gameResultModelTotalToJson(GameResultModelTotal data) =>
    json.encode(data.toJson());

class GameResultModelTotal {
  GameResultModelTotal(
      {this.dateTime,
      this.date,
      this.time,
      this.gameResultModel,
      this.lastResult});
  DateTime? dateTime;
  DateTime? date;
  String? time;
  List<GameResultModel>? gameResultModel;
  LastResult? lastResult;

  factory GameResultModelTotal.fromJson(Map<String, dynamic> json) =>
      GameResultModelTotal(
        dateTime: DateTime.parse(json["date_time"]),
        date: DateTime.parse(json["date"]),
        time: json["time"],
        gameResultModel: List<GameResultModel>.from(
            json["GameResultModel"].map((x) => GameResultModel.fromJson(x))),
        lastResult: LastResult.fromJson(json["lastResult"]),
      );

  Map<String, dynamic> toJson() => {
        "date_time": dateTime?.toIso8601String(),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "GameResultModel":
            List<dynamic>.from(gameResultModel!.map((x) => x.toJson())),
        "lastResult": lastResult!.toJson(),
      };
}
