class BMI {
  static double getBmi({required int height, required int weight}) {
    int h = height;
    int w = weight;
    double v = w / ((h / 100) * (h / 100));
    print("BMI:: $w $h $v");
    double value;
    if (v < 18.5) {
      value = 22.5;
    } else if (v >= 18.5 && v < 24.9) {
      value = 45;
    } else if (v >= 24.9 && v < 29.9) {
      value = 75;
    } else {
      value = 105;
    }
    return value;
  }

  static double getBmiExact({required int height, required int weight}) {
    int h = height;
    int w = weight;
    print("BMI::: $w $h");
    double v = w / ((h * h) / 10000);

    return v;
  }

  static String getBmiExactText({required int height, required int weight}) {
    int h = height;
    int w = weight;
    print("BMI::: $w $h");
    double v = w / ((h * h) / 10000);
    String value = "";
    if (v < 18.5) {
      value = "You are underweight";
    } else if (v >= 18.5 && v < 24.9) {
      value = "You are normal weight";
    } else if (v >= 24.9 && v < 29.9) {
      value = "You are Overweight";
    } else {
      value = "You have obesity";
    }

    return value;
  }
  static String getBmiExactTextByValue(dynamic bmi) {

    double v = double.parse(bmi);
    String value = "";
    if (v < 18.5) {
      value = "You are underweight";
    } else if (v >= 18.5 && v < 24.9) {
      value = "You are normal weight";
    } else if (v >= 24.9 && v < 29.9) {
      value = "You are Overweight";
    } else {
      value = "You have obesity";
    }

    return value;
  }
}
