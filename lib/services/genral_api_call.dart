import 'package:susu/models/bid_history_model.dart';
import 'package:susu/models/get_transaction_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:susu/utils/links.dart';

import '../models/block_upis.dart';

class GenralApiCallService {
  Future<List<BidHistoryModel?>?> fetchGenralQuery(String genralSQL) async {
    Map data = {
      'my_genral_query': genralSQL,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        List<BidHistoryModel> l = bidHistoryModelFromJson(jsonbody);
        for (var item in l) {
          print(item.gameName);
        }
        return bidHistoryModelFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<GetTransation?>?> fetchTransactionAddAmount(
      String genralSQL) async {
    Map data = {
      'my_genral_query': genralSQL,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        print(jsonbody);
        print("Rtuen state from fetchTransactionAddAmount");
        List<GetTransation?>? l = getTransationFromJson(jsonbody);

        return l;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> fetchGenralQueryWithRawData(String genralSQL) async {
    Map data = {
      'my_genral_query': genralSQL,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);

        return jsonbody;
      } else {
        return "no data";
      }
    } catch (e) {
      return "no data";
    }
  }

  static Future<List<String>> blockUpi() async {
    Map data = {
      "block_upis": "true",
      'tk': token2,
    };
    List<String> listBlockUpiString = [];
    var url = Uri.parse(main_url);
    var response = await http.Client().post(
      url,
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        List<BlockUpis> listBlockUpi = blockUpisFromJson(jsonbody);
        List<String> listBlockUpiString =
            listBlockUpi.map((e) => e.upi!.toLowerCase()).toList();
        return listBlockUpiString;
      } else {
        return listBlockUpiString;
      }
    } catch (e) {
      return listBlockUpiString;
    }
  }

  Future<String> setOTP(String phone, int random) async {
    // Map data = {
    //       "async": true,
    //       "crossDomain": true,
    //       "url": "https://2factor.in/API/V1/d5fac988-dadf-11e9-ade6-0200cd936042/SMS/" + phone + "/" + random.toString() + "/Otp lion",
    //       "method": "GET",
    //       "headers": {
    //         "content-type": "application/x-www-form-urlencoded"
    //       },
    //       "data": {}
    //     };

    var url = Uri.parse(
        "https://2factor.in/API/V1/d5fac988-dadf-11e9-ade6-0200cd936042/SMS/" +
            phone +
            "/" +
            random.toString() +
            "");
    print(
        "https://2factor.in/API/V1/d5fac988-dadf-11e9-ade6-0200cd936042/SMS/" +
            phone +
            "/" +
            random.toString() +
            "");
    var response = await http.Client().get(url,
        headers: {"content-type": "application/x-www-form-urlencoded"});
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);

        return jsonbody;
      } else {
        return "no data";
      }
    } catch (e) {
      return "no data";
    }
  }

  Future<String?> fetchGenralQueryNormal(
      String sql, String success, String failure) async {
    Map data = {
      'my_genral_query_insert_update': sql,
      'success': success,
      'failure': failure,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        return jsonbody;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

//$_POST['funduserid']) && isset($_POST['amount']
  Future<String?> addfundRozarPay(String amount) async {
    var box = GetStorage();
    Map data = {
      'funduserid': box.read("id"),
      'amount': amount,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        return jsonbody;
      } else {
        return "no";
      }
    } catch (e) {
      return "no";
    }
  }
}
