import 'package:susu/pages/calorie_count_page.dart';

class BMR {
  static double getBMR(
      {required String gender,
      required int weight,
      required int height,
      required int age}) {
    if (gender == Gender.male) {
      return 66.5 + (13.75 * weight) + (5.003 * height) - (6.75 * age);
    } else {
      return 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
    }
  }
  activityList(){
    
  }


}
