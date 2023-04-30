// To parse this JSON data, do
//
//     final getInviteDetail = getInviteDetailFromJson(jsonString);

import 'dart:convert';

GetInviteDetail getInviteDetailFromJson(String str) =>
    GetInviteDetail.fromJson(json.decode(str));

String getInviteDetailToJson(GetInviteDetail data) =>
    json.encode(data.toJson());

class GetInviteDetail {
  GetInviteDetail({
    this.todayContribution="0",
    this.totalContribution="0",
    this.todayActiveUSer="0",
    this.totalUser="0",
    this.bonus="0",
  });

  String? todayContribution;
  String? totalContribution;
  String? todayActiveUSer;
  String? totalUser;
  String? bonus;

  factory GetInviteDetail.fromJson(Map<String, dynamic> json) =>
      GetInviteDetail(
        todayContribution: json["todayContribution"],
        totalContribution: json["totalContribution"],
        todayActiveUSer: json["todayActiveUSer"],
        totalUser: json["totalUser"],
        bonus: json["bonus"],
      );

  Map<String, dynamic> toJson() => {
        "todayContribution": todayContribution,
        "totalContribution": totalContribution,
        "todayActiveUSer": todayActiveUSer,
        "totalUser": totalUser,
        "bonus": bonus,
      };
}
