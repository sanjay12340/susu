import 'dart:convert';
import 'dart:developer';

import 'package:susu/models/game_and_type_model.dart';
import 'package:susu/models/get_invite_detail_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:susu/models/game_play_condition_model.dart';
import 'package:susu/models/game_result_model.dart';

import 'package:susu/models/game_result_model_total.dart';
import 'package:susu/pages/Login.dart';

import 'package:susu/utils/links.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:get/get.dart';

import '../models/game_list.dart';
import '../models/user_create_model.dart';

class RemoteGameResultService {
  static var client = http.Client();

  static Future<List<GameResultModel>?> fetchGameResult() async {
    var url = Uri.parse("$main_url" + "$token" + "&game_result=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameResultModelFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<GameResultModelTotal?> fetchGameResultWithTime(
      {String? gameId}) async {
    var url = Uri.parse(
        "$main_url" + "$token" + "&game_result_with_dt=yes&game_id=${gameId}");
    var responce = await client.get(url);
    print(responce.body);
    print(responce.statusCode);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        print(jsonbody);

        return gameResultModelTotalFromJson(responce.body);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<GameList>?> fetchGameResultWithTimeMain() async {
    var url =
        Uri.parse("$main_url" + "$token" + "&game_result_with_dt_main=yes");
    var responce = await client.get(url);
    print("test");
    print(responce.body);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        print(jsonbody);
        return gameListFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  // static Future<Map<String,dynamic>> fetchGameResultWithTimeLastResult() async {
  //   var url = Uri.parse("$main_url" + "$token" + "&game_result_with_dt_last_result=yes");
  //   var responce = await client.get(url);
  //   print(responce.body);
  //   try {
  //     if (responce.statusCode == 200) {
  //       var jsonbody = responce.body;
  //       print(jsonbody);
  //       return gameResultModelTotalFromJson(jsonbody);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<GameAndType?> fetchGameType() async {
    var url = Uri.parse("$main_url" + "$token" + "&get_game_type=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameAndTypeFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<GameAndType?> fetchGameTimes() async {
    var url = Uri.parse("$main_url" + "$token" + "&get_game_time=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameAndTypeFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Game?>?> fetchGameList() async {
    var url = Uri.parse("$main_url" + "$token" + "&game_list=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<GamePlayConditionModel?> checkPlayCondtion(
      int gameId, String? time) async {
    var url =
        Uri.parse("$main_url" "$token" "&gettimeupdate=$gameId&time=$time");
    var responce = await client.get(url);

    if (responce.statusCode == 200) {
      var jsonbody = jsonDecode(responce.body);
      print(jsonbody);
      return GamePlayConditionModel(playstatus: jsonbody['playstatus']);
    } else {
      return GamePlayConditionModel(playstatus: false);
    }
  }

  Future<bool> logincheck2(
      String username, String password, String fmctoken) async {
    final box = GetStorage();
    Map data = {
      'appuser': username,
      'apppass': password,
      'fmctoken': fmctoken,
      'tk': token2,
    };
    print(data);
    print(main_url);
    var url = Uri.parse(main_url);
    var response = await client.post(
      url,
      body: data,
    );
    var json = jsonDecode(response.body);
    print(json);
    if (json["status"]) {
      //`phonepe`, `paytm`, `gpay`, `bank_name`, `account_number`, `ifsc`
      box.write('isLogedIn', json["status"]);
      box.write('id', json["data"]["user_id"]);
      box.write('username', json["data"]["usrname"]);
      box.write('phone', json["data"]["phone"]);
      box.write('password', json["data"]["password"]);
      box.write('pnotice', json["data"]["pnotice"]);
      box.write('notice1', json["data"]["notice1"]);
      box.write('money', json["data"]["money"]);
      box.write('phonepe', json["data"]["phonepe"]);
      box.write('paytm', json["data"]["paytm"]);
      box.write('gpay', json["data"]["gpay"]);
      box.write('bank_name', json["data"]["bank_name"]);
      box.write('account_number', json["data"]["account_number"]);
      box.write('ifsc', json["data"]["ifsc"]);
      box.write(StorageConstant.active, json["data"]["status"] == "active");
      box.write(StorageConstant.play, json["data"]["play"] == "active");
      box.write(StorageConstant.live, json["data"]["live"] == "1");

      log(box.read(StorageConstant.active).toString(), name: "active");
    }

    return json["status"] ?? false;
  }

  Future<bool> createNewUser(
      String username, String password, String phone) async {
    Map data = {
      'uname': username,
      'pass': password,
      'phone': phone,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return json["status"];
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<GetInviteDetail> getInviteDetail() async {
    print("Method getInviteDetail");
    final box = GetStorage();
    Map data = {
      'gamecontribution': "true",
      'userid': box.read('id'),
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );
    print("Test" + response.body);
    try {
      if (response.statusCode == 200) {
        GetInviteDetail json;
        json = getInviteDetailFromJson(response.body);
        return json;
      } else {
        GetInviteDetail json = GetInviteDetail(
            bonus: '0.00',
            todayActiveUSer: '0',
            todayContribution: '0.00',
            totalUser: '0');
        return json;
      }
    } catch (e) {
      GetInviteDetail json = GetInviteDetail(
          bonus: '0.00',
          todayActiveUSer: '0',
          todayContribution: '0.00',
          totalUser: '0');
      return json;
    }
  }

  Future<bool> createNewUserRef(String username, String password, String phone,
      String ref, String? fmctoken) async {
    Map data = {
      'username': username,
      'password': password,
      'phone': phone,
      "fmctoken": fmctoken ?? "no",
      'ref': ref,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );

    print(response.body);
    try {
      if (response.statusCode == 200) {
        var box = GetStorage();

        var json = jsonDecode(response.body);
        print(json);
        UserCreateModel userCreateModel =
            userCreateModelFromJson(response.body);

        if (userCreateModel.status!) {
          box.write(StorageConstant.isLoggedIn, userCreateModel.status);

          box.write(StorageConstant.id, userCreateModel.data!.userId);
          box.write(StorageConstant.username, userCreateModel.data!.usrname);
          box.write(StorageConstant.phone, userCreateModel.data!.phone);
          box.write(StorageConstant.pnotice, userCreateModel.data!.pnotice);
          box.write(StorageConstant.notice1, userCreateModel.data!.notice1);
          box.write(StorageConstant.money, userCreateModel.data!.money);
          box.write(StorageConstant.phonepe, userCreateModel.data!.phonepe);
          box.write(StorageConstant.paytm, userCreateModel.data!.paytm);
          box.write(StorageConstant.gpay, userCreateModel.data!.gpay);
          box.write(StorageConstant.name, userCreateModel.data!.bankName);
          box.write(StorageConstant.account_number,
              userCreateModel.data!.accountNumber);
          box.write(StorageConstant.ifsc, userCreateModel.data!.ifsc);
          box.write(
              StorageConstant.active, userCreateModel.data!.status == "active");
          box.write(
              StorageConstant.play, userCreateModel.data!.play == "active");
          box.write(StorageConstant.live, userCreateModel.data!.live == "1");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String?, dynamic>> checkBalance() async {
    final box = GetStorage();
    Map data = {
      'appuserid': box.read("id"),
      'myblanace': "yes",
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      log(response.body, name: "checkbalance");
      map["status"] = true;
      map["money"] = json['money'];
      box.write(StorageConstant.play, json['play']);
      if (!json['mystatus']) {
        box.write(StorageConstant.isLoggedIn, false);
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Alert",
            middleText: "Your Account is Suspended",
            onConfirm: () {
              Get.back();
              Get.to(LoginPage());
            });
      }
      if (!json["live"]) {
        box.write(StorageConstant.live, false);
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Alert",
            middleText: "Your Account is on show mode",
            onConfirm: () {
              Get.back();
            });
      } else {
        box.write(StorageConstant.live, true);
      }

      return map;
    } else {
      map["status"] = false;
      return map;
    }
  }
}
