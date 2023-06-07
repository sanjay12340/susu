import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:susu/pages/calorie_count_page.dart';
import 'package:susu/utils/storage_constant.dart';

class Util {
  static String caloriesBurn(int time, double meet, double weight) {
    print("${time}*${meet}*$weight*3.5/200");
    return (time * meet * weight * 3.5 / 200).toStringAsFixed(2);
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static int myAge() {
    var box = GetStorage();
    DateTime currentDate = DateTime.now();
    DateTime birthDate =
        DateFormat("yyyy-MM-dd").parse(box.read(StorageConstant.dob));
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static int calculateFromDateAge(DateTime birthDate, [DateTime? fromDate]) {
    DateTime currentDate = fromDate ?? DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static double getBMR(
      {required Gender gender,
      required int weight,
      required int height,
      required int age}) {
    if (gender == Gender.male) {
      print("Male   ${gender}");
      return 66.5 + (13.75 * weight) + (5.003 * height) - (6.75 * age);
    } else {
      print("Other    ${gender}");
      return 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
    }
  }

  static double myBMR() {
    var box = GetStorage();
    int weight = int.parse(box.read(StorageConstant.weight));
    int height = int.parse(box.read(StorageConstant.height));
    int age = myAge();
    if (box.read(StorageConstant.gender) == "male") {
      return 66.5 + (13.75 * weight) + (5.003 * height) - (6.75 * age);
    } else {
      return 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
    }
  }

  static String sleepByAge() {
    int age = myAge();
    if (age >= 6 && age <= 12) {
      return "9-12";
    } else if (age >= 13 && age <= 18) {
      return "8-10";
    } else if (age >= 18 && age <= 60) {
      return "7 or more";
    } else if (age >= 61 && age <= 64) {
      return "7-9";
    } else if (age >= 65) {
      return "7-8";
    } else {
      return "";
    }
  }

  static void storeValueOfUser(Map<String, dynamic> user) {
    var box = GetStorage();
    box.write(StorageConstant.id, user['id']);
    box.write(StorageConstant.isLoggedIn, true);
    box.write(StorageConstant.username, user['username']);
    box.write(StorageConstant.name, user['name']);
    box.write(StorageConstant.dob, user['dob']);
    box.write(StorageConstant.email, user['email']);
    box.write(StorageConstant.user_type, user['user_type']);
    box.write(StorageConstant.gender, user['sex']);
    box.write(StorageConstant.height, user['height']);
    box.write(StorageConstant.weight, user['weight']);
    box.write(StorageConstant.point, user['point']);
    box.write(StorageConstant.profile_lock,
        user['profile_lock'] != null ? user['profile_lock'] == "1" : true);
    box.write(StorageConstant.new_order_lock,
        user['new_order_lock'] != null ? user['new_order_lock'] == "1" : true);
    box.write(StorageConstant.next_date, user['next_date']);
    box.write(StorageConstant.lastOrderDate, user['last_order_date']);
    box.write(StorageConstant.userStatus, user['user_status'] == "1");
  }
}
