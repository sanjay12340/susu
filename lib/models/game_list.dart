// To parse this JSON data, do
//
//     final gameList = gameListFromJson(jsonString);

import 'dart:convert';

List<GameList> gameListFromJson(String str) =>
    List<GameList>.from(json.decode(str).map((x) => GameList.fromJson(x)));

String gameListToJson(List<GameList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameList {
  GameList({
    this.name,
    this.status,
    this.type,
    this.id,
    this.gameId,
    this.pana,
    this.number,
    this.date,
    this.time,
    this.createdAt,
  });

  String? name;
  String? status;
  String? type;
  String? id;
  String? gameId;
  String? pana;
  String? number;
  String? date;
  String? time;
  String? createdAt;

  factory GameList.fromJson(Map<String, dynamic> json) => GameList(
        name: json["name"],
        status: json["status"],
        type: json["type"],
        id: json["id"],
        gameId: json["game_id"],
        pana: json["pana"],
        number: json["number"],
        date: json["date"],
        time: json["time"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "status": status,
        "type": type,
        "id": id,
        "game_id": gameId,
        "pana": pana,
        "number": number,
        "date": date,
        "time": time,
        "created_at": createdAt,
      };
}
