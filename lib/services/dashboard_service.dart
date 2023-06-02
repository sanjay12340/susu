import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:susu/models/calorie_history_detail_modal.dart';
import 'package:susu/models/register_user_model.dart';
import 'package:susu/models/sleep_history_detail_modal.dart';
import 'package:susu/models/user_order_detail_modal.dart';
import 'package:susu/utils/storage_constant.dart';

import '../models/order_detail_full_modal.dart';
import '../models/order_history_modal.dart';
import '../models/report_submit_modal.dart';
import '../models/result_variables_modal.dart';
import '../models/step_history_detail_modal.dart';
import '../models/test_data_modal.dart';
import '../models/water_history_detail_modal.dart';
import '../utils/links.dart';

class DashboardService {
  static var client = http.Client();
  static var box = GetStorage();

  static Future<List<ResultVariablesModal>?> fetchResultVariable() async {
    var url = Uri.parse("$main_url$token&get_report_valiables=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return resultVariablesModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> resetPassword(
      String email, String otp) async {
    String uri = "$main_url$token&reset_password=yes&email=$email&otp=$otp";
    print(uri);
    var url = Uri.parse(uri);
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return jsonDecode(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<UserOrderDetailModal?> fetchUserDetailByOrderNo(
      {required String orderNo}) async {
    String uri = "$main_url$token&fetch_user_order_no=$orderNo";
    print(uri);
    var url = Uri.parse(uri);
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        print(jsonbody);
        return userOrderDetailModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString(), name: "Error Fetch ${e}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createNewAccount(
      RegisterUserModal registerUserModal) async {
    var data = jsonEncode(registerUserModal);
    Map<String, dynamic> map = {
      "create_new_user": data,
      "tk": token2,
    };
    if (kDebugMode) {
      print("assdasadas $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> saveUpdatePoints(
      int points, bool credit) async {
    Map<String, dynamic> map = {
      "point_update": "yes",
      "user_id": box.read(StorageConstant.id),
      "credit": credit,
      "points": points,
      "tk": token2,
    };

    if (kDebugMode) {
      print("assdasadas $map");
    }
    String uri = main_url + "" + token;

    map.forEach((key, value) {
      uri += "&$key=${value}";
    });
    print(uri);
    var url = Uri.parse(uri);
    var response = await client.get(url);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Catch $e");
    }
  }

  static Future<Map<String, dynamic>?> catpturTest(String orderId) async {
    Map<String, dynamic> map = {
      "capture_order": "yes",
      "order_id": orderId,
      "lab_id": box.read(StorageConstant.id),
      "tk": token2,
    };
    if (kDebugMode) {
      print("assdasadas $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateUserInfo(
      {String? name,
      String? dob,
      String? gender,
      String? height,
      String? weight}) async {
    Map<String, dynamic> map = {
      "update_user_info": "yes",
      "name": name ?? box.read(StorageConstant.name),
      "dob": dob ?? box.read(StorageConstant.dob),
      "gender": gender ?? box.read(StorageConstant.gender),
      "height": height ?? box.read(StorageConstant.height),
      "weight": weight ?? box.read(StorageConstant.weight),
      "user_id": box.read(StorageConstant.id),
      "tk": token2,
    };
    if (kDebugMode) {
      print("assdasadas $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    print(response.body);
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString(), name: "Error Update");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    Map<String, dynamic> map = {
      "login": "yes",
      "username": username,
      "password": password,
      "tk": token2,
    };
    if (kDebugMode) {
      print("assdasadas $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> bookTest({
    required String date,
    required String time,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pin,
    required String phone,
    required String userId,
    String? addressId,
  }) async {
    Map<String, dynamic> map = {
      "book_test": "yes",
      "date": date,
      "time": time,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "pin": pin,
      "phone": phone,
      "user_id": userId,
      "tk": token2,
    };
    if (addressId != null) {
      map['address_id'] = addressId;
    }
    if (kDebugMode) {
      print("assdasadas $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> openReportConsumePoints({
    required int points,
    required String type,
    required String orderID,
  }) async {
    Map<String, dynamic> map = {
      "open_report_points": "yes",
      "points": points.toString(),
      "type": type,
      "order_id": orderID,
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchLatestReport(String userId) async {
    print("$main_url$token&latest_report=yes&user_id$userId");
    var url = Uri.parse("$main_url$token&latest_report=yes&user_id=$userId");
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<TestDataModal?> fetchOrders(
      {String? date,
      String? labId,
      String? status,
      String? upcomingTodayHistory,
      required int limit,
      required int offset,
      String? orderBy}) async {
    String uri = "$main_url$token&lab_orders=yes&limit=$limit&offset=$offset";
    if (status != null) {
      uri += "&status=$status";
    }
    if (upcomingTodayHistory != null) {
      uri += "&upcomingTodayHistory=$upcomingTodayHistory";
    }
    if (date != null) {
      uri += "&date=$date";
    }
    if (labId != null) {
      uri += "&lab_id=$labId";
    }
    if (orderBy != null) {
      uri += "&order_by=$orderBy";
    }

    print(uri);
    var url = Uri.parse(uri);
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        return testDataModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

// Save Report Detail
  static Future<Map<String, dynamic>?> saveReportDeatil({
    required List<ReportSubmitData> report,
    required String orderId,
  }) async {
    print(report.toString());
    Map<String, dynamic> map = {
      "save_report_data": jsonEncode(report),
      "user_id": box.read(StorageConstant.id),
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

// Save Report Detail End

// Water Service
  static Future<Map<String, dynamic>?> saveWaterIntake({
    required int glass,
    required String userId,
  }) async {
    Map<String, dynamic> map = {
      "save_water_intake": "yes",
      "glass": glass.toString(),
      "user_id": userId,
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<WaterHistoryDetailModal?> fetchWaterReport(
      String userId, int limit) async {
    print(
        "$main_url$token&fetch_water_intake=yes&user_id=$userId&limit=$limit");
    var url = Uri.parse(
        "$main_url$token&fetch_water_intake=yes&user_id=$userId&limit=$limit");
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        if (kDebugMode) {
          print(jsonbody);
        }
        return waterHistoryDetailModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      print("catch $e");
      return null;
    }
  }

// Water Service End

//step Track
  static Future<StepHistoryDetailModal?> fetchStepTrack(
      {required String userId, required int limit}) async {
    print("$main_url$token&fetch_step_track=yes&user_id=$userId");
    try {
      var url = Uri.parse(
          "$main_url$token&fetch_step_track=yes&user_id=$userId&limit=$limit&offset=0");
      var response = await client.get(url);

      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        return stepHistoryDetailModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      print("catch $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> saveStepTrack({
    required int step,
    required String userId,
  }) async {
    Map<String, dynamic> map = {
      "save_step": "yes",
      "step": step.toString(),
      "user_id": userId,
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

//step track end

// Sleep Track

  static Future<SleepHistoryDetailModal?> fetchSleepTrack(
      {required String userId, required int limit}) async {
    print("$main_url$token&fetch_step_track=yes&user_id=$userId");
    var url = Uri.parse(
        "$main_url$token&fetch_sleep_track=yes&user_id=$userId&limit=$limit&offset=0");
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        return sleepHistoryDetailModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      print("catch $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> saveSleepTrack({
    required String startTime,
    required String endTime,
    required String durationTime,
    required String userId,
  }) async {
    Map<String, dynamic> map = {
      "save_sleep_track": "yes",
      "start": startTime,
      "end": endTime,
      "duration": durationTime,
      "user_id": userId,
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
// Sleep Track End

//calorie
  static Future<CalorieHistoryDetailModal?> fetchCalorieTrack(
      {required String userId, required int limit}) async {
    print("$main_url$token&fetch_calorie_track=yes&user_id=$userId");
    try {
      var url = Uri.parse(
          "$main_url$token&fetch_calorie_track=yes&user_id=$userId&limit=$limit&offset=0");
      var response = await client.get(url);

      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        return calorieHistoryDetailModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      print("catch $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> saveCalorieTrack({
    required String cal,
    required String userId,
  }) async {
    Map<String, dynamic> map = {
      "save_calorie_track": "yes",
      "cal": cal.toString(),
      "user_id": userId,
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
//calorie end

//Nutrition Save
  static Future<Map<String, dynamic>?> saveNutritionDiet({
    required String bodyType,
    required String diet,
    required String allergy,
    required String userId,
  }) async {
    Map<String, dynamic> map = {
      "save_nutrition": "yes",
      "body_type": bodyType,
      "diet": diet,
      "allergy": allergy,
      "user_id": userId,
      "tk": token2,
    };

    if (kDebugMode) {
      print("Data::: $map");
    }
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: map,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

//Nutrition Save end
  static Future<OrderDetailFullModal?> fetchReportDetailFull(
      String orderId) async {
    var url = Uri.parse(
        "$main_url$token&fetch_order_detail_full=yes&order_id=$orderId");
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        return orderDetailFullModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<OrderDetailFullModal?> fetchReportDetailFullByMonth(
      String date) async {
    String uri =
        "$main_url$token&fetch_order_detail_full_by_month=yes&user_id=${box.read(StorageConstant.id)}&date=$date";
    print(uri);
    var url = Uri.parse(uri);
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        return orderDetailFullModalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<OrderHistoryPage?> fetchOrderHistory(
      {required String userId, required int limit, required int offset}) async {
    var url = Uri.parse(
        "$main_url$token&fetch_order_history=yes&user_id=$userId&limit=$limit&offset=$offset");
    var responce = await client.get(url);
    print(jsonEncode(url.queryParameters));
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        print(jsonbody);
        return orderHistoryPageFromJson(jsonbody);
      } else {
        print("else ");
        return null;
      }
    } catch (e) {
      print("catch ${e}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAddress(String userId) async {
    print("$main_url$token&fetch_address=yes&user_id$userId");
    var url = Uri.parse("$main_url$token&fetch_address=yes&user_id=$userId");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        print(jsonbody);
        Map<String, dynamic> map = jsonDecode(jsonbody);

        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
