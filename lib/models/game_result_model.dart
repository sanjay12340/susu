// To parse this JSON data, do
//
//     final gameResultModel = gameResultModelFromJson(jsonString);

import 'dart:convert';

List<GameResultModel> gameResultModelFromJson(String str) =>
    List<GameResultModel>.from(
        json.decode(str).map((x) => GameResultModel.fromJson(x)));

String gameResultModelToJson(List<GameResultModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameResultModel {


    GameResultModel({
        this.id,
        this.time,
        this.days,
        this.gameOnOff,
        this.gameName,
        this.ct,
        this.resultTime,
        this.closeTime,
        this.nextday,
        this.mor,
        this.result,
        this.result2,
    });

    String? id;
    String? time;
    String? days;
    String? gameOnOff;
    String? gameName;
    String? ct;
    String? resultTime;
    String? closeTime;
    String? nextday;
    String? mor;
    String? result;
    String? result2;

    factory GameResultModel.fromJson(Map<String, dynamic> json) => GameResultModel(
        id: json["id"],
        time: json["time"],
        days: json["days"],
        gameOnOff: json["game_on_off"],
        gameName: json["game_name"],
        ct: json["ct"],
        resultTime: json["result_time"],
        closeTime: json["close_time"],
        nextday: json["nextday"],
        mor: json["mor"],
        result: json["result"],
        result2: json["result2"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "days": days,
        "game_on_off": gameOnOff,
        "game_name": gameName,
        "ct": ct,
        "result_time": resultTime,
        "close_time": closeTime,
        "nextday": nextday,
        "mor": mor,
        "result": result,
        "result2": result2,
    };
}


