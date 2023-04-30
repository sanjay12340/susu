// To parse this JSON data, do
//
//     final gameAndType = gameAndTypeFromJson(jsonString);

import 'dart:convert';

GameAndType gameAndTypeFromJson(String str) =>
    GameAndType.fromJson(json.decode(str));

List<Game?>? gameFromJson(String str) => json.decode(str) == null ? [] : List<Game?>.from(json.decode(str)!.map((x) => Game.fromJson(x)));

String gameToJson(List<Game?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));


String gameAndTypeToJson(GameAndType data) => json.encode(data.toJson());

class GameAndType {
  GameAndType({
    this.gameTypeModel,
    this.game,
    this.gametime,
  });

  List<GameTypeModel>? gameTypeModel;
  List<Game>? game;
  List<Gametime>? gametime;

  factory GameAndType.fromJson(Map<String, dynamic> json) => GameAndType(
        gameTypeModel: List<GameTypeModel>.from(
            json["GameTypeModel"].map((x) => GameTypeModel.fromJson(x))),
        game: List<Game>.from(json["Game"].map((x) => Game.fromJson(x))),
        gametime: List<Gametime>.from(
            json["Gametime"].map((x) => Gametime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "GameTypeModel":
            List<dynamic>.from(gameTypeModel!.map((x) => x.toJson())),
        "Game": List<dynamic>.from(game!.map((x) => x.toJson())),
        "Gametime": List<dynamic>.from(gametime!.map((x) => x.toJson())),
      };
}

class Game {
  Game({
    this.id,
    this.gameName,
  });

  String? id;
  String? gameName;

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json["id"],
        gameName: json["game_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "game_name": gameName,
      };
}

class GameTypeModel {
  GameTypeModel({
    this.id,
    this.name,
    this.fname,
    this.price,
  });

  String? id;
  String? name;
  String? fname;
  String? price;

  factory GameTypeModel.fromJson(Map<String, dynamic> json) => GameTypeModel(
        id: json["id"],
        name: json["name"],
        fname: json["fname"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fname": fname,
        "price": price,
      };
}

class Gametime {
  Gametime({
    this.time,
    this.showTime,
  });

  String? time;
  String? showTime;

  factory Gametime.fromJson(Map<String, dynamic> json) => Gametime(
        time: json["time"],
        showTime: json["show_time"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "show_time": showTime,
      };
}
