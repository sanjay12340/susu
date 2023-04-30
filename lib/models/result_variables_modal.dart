// To parse this JSON data, do
//
//     final resultVariablesModal = resultVariablesModalFromJson(jsonString);

import 'dart:convert';

List<ResultVariablesModal> resultVariablesModalFromJson(String str) =>
    List<ResultVariablesModal>.from(
        json.decode(str).map((x) => ResultVariablesModal.fromJson(x)));

String resultVariablesModalToJson(List<ResultVariablesModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResultVariablesModal {
  ResultVariablesModal({
    this.id,
    this.name,
    this.star,
    this.end,
    this.alise,
    this.dimention,
  });

  final String? id;
  final String? name;
  final String? star;
  final String? end;
  final String? alise;
  final String? dimention;

  factory ResultVariablesModal.fromJson(Map<String, dynamic> json) =>
      ResultVariablesModal(
        id: json["id"],
        name: json["name"],
        star: json["star"],
        end: json["end"],
        alise: json["alise"],
        dimention: json["dimention"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "star": star,
        "end": end,
        "alise": alise,
        "dimention": dimention,
      };
}
