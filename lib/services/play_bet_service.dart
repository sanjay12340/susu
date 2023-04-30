import 'dart:convert';

import 'package:susu/models/bet_number_half_full_modal.dart';

import 'package:http/http.dart' as http;
import 'package:susu/models/bet_number_modal.dart';
import 'package:susu/utils/links.dart';

class PlayBet {
  static var client = http.Client();

  static Future<Map<String, dynamic>> playBetGame(
      List<BetNumberModal> myjson) async {
    var data = jsonEncode(myjson);
    Map<String, dynamic> map = {"data": data, "tk": token2, "playbet": "true"};
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    Map<String, dynamic> back = new Map<String, dynamic>();
    print(response.body);
    if (response.statusCode == 200) {
      if (response.body.contains("yes")) {
        back["status"] = true;
        back["mag"] = "Bid is Sucessfull";
        return back;
      } else {
        back["status"] = false;
        back["mag"] = "Bid is Failed";
        return back;
      }
    } else {
      back["status"] = false;
      back["mag"] = "Bid is Failed";
      return back;
    }
  }

  static Future<Map<String, dynamic>> playBetGameHalfFull(
      List<BetNumberHalfFullModal> myjson) async {
    var data = jsonEncode(myjson);
    Map<String, dynamic> map = {
      "bet_is_done_half_and_full_sangam": data,
      "tk": token2,
    };
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    print(response.body);
    Map<String, dynamic> back = new Map<String, dynamic>();
    if (response.statusCode == 200) {
      if (response.body.contains("yes")) {
        back["status"] = true;
        back["mag"] = "Bid is Sucessfull";
        return back;
      } else {
        back["status"] = false;
        back["mag"] = "Bid is Failed";
        return back;
      }
    } else {
      back["status"] = false;
      back["mag"] = "Bid is Failed";
      return back;
    }
  }
}
