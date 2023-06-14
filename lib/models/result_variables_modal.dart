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
    this.start,
    this.fname,
    this.end,
    this.alias,
    this.dimention,
  });

  final String? id;
  final String? name;
  final String? start;
  final String? end;
  final String? fname;
  final String? alias;
  final String? dimention;

  factory ResultVariablesModal.fromJson(Map<String, dynamic> json) =>
      ResultVariablesModal(
        id: json["id"],
        name: json["name"],
        start: json["start"],
        end: json["end"],
        fname: json["fname"],
        alias: json["alias"],
        dimention: json["dimention"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start": start,
        "end": end,
        "alias": alias,
        "dimention": dimention,
      };
}
