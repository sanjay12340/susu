import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/pages/Login.dart';
import 'package:susu/pages/bmi_page.dart';
import 'package:susu/pages/book_test_page.dart';
import 'package:susu/pages/calorie_count_page.dart';
import 'package:susu/pages/nutrition_count_page.dart';
import 'package:susu/pages/sleep_count_page.dart';
import 'package:susu/pages/step_count_page.dart';
import 'package:susu/pages/test_history_page.dart';
import 'package:susu/pages/water_pages.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String? name;
  bool isCardView = true;
  String reportFound = "Wait..";
  String reportDate = "";
  var lastReport = List<ReportResultModal>.empty(growable: true);
  var box = GetStorage();
  List<TableRow> reportData = [];
  var underWeight = Colors.orange;
  var good = Colors.green;
  var overWeight = Colors.red;
  var obesity = Colors.brown;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchLatestReport();
  }

  void fetchLatestReport() {
    DashboardService.fetchLatestReport(box.read(StorageConstant.id))
        .then((value) {
      if (value == null) {
        setState(() {
          reportFound = "Recent test result not found";
        });
      } else if (value['status']) {
        setState(() {
          reportFound = "";
          reportDate = value['date'];
          reportData.add(TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black45))),
              children: [
                tableCellHead("Description"),
                tableCellHead("Range", true),
                tableCellHead("Value", true),
              ]));
          List<dynamic> rd = value['data'];
          print(rd);

          for (var element in rd) {
            Map<String, dynamic> e = element;
            reportData.add(
              TableRow(children: [
                tableCell(e['name'], false, true),
                tableCell(e['alise'], true),
                tableCell(e['value'], true),
              ]),
            );
          }
        });
      } else {
        setState(() {
          reportFound = "Recent test result not found";
        });
      }
    });
  }

  void addTemp() {
    lastReport.add(
        ReportResultModal(name: "Glucose", range: "14-15 Mg/dl", value: "11"));
    lastReport.add(
        ReportResultModal(name: "Keton", range: "9-10 Mg/dl", value: "12"));
    lastReport.add(ReportResultModal(
        name: "Bilirubin", range: "1.3 -1.8 Mg", value: "2.0"));
    lastReport
        .add(ReportResultModal(name: "pH level", range: "7-8", value: "6"));
    lastReport.add(ReportResultModal(
        name: "Spacific Gravity", range: "1.005-1.030", value: "2"));
  }

  TableCell tableCell(name, [bool? center, bool bold = false]) => TableCell(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: center != null && center
              ? Center(
                  child: Text(
                  name,
                  style: TextStyle(
                      fontWeight: bold ? FontWeight.bold : FontWeight.normal),
                ))
              : Text(
                  name,
                  style: TextStyle(
                      fontWeight: bold ? FontWeight.bold : FontWeight.normal),
                )));
  TableCell tableCellHead(String name, [bool? center, bool bold = false]) =>
      TableCell(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: center != null && center
            ? Center(
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ));
  void goTO(Widget goTo) {
    _key.currentState!.openEndDrawer();
    Get.to(() => goTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Susu"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              box.erase();
              Get.offAll(LoginPage());
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.logout_outlined)),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: myWhite,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.account_circle,
                        color: myPrimaryColorDark,
                        size: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            box.read("name"),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            box.read("username"),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Point : ${box.read(StorageConstant.point) ?? 0.toString()}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomListMenuItem(
              name: "My Profile",
              leadingIcon: Icons.person,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(AccountPage());
              },
            ),
            CustomListMenuItem(
              name: "Book A Test",
              leadingIcon: Icons.bookmark_add,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(BookTestPage());
              },
            ),
            CustomListMenuItem(
              name: "Order History",
              leadingIcon: Icons.history,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(AccountPage());
              },
            ),
            CustomListMenuItem(
              name: "Logout",
              leadingIcon: Icons.logout,
              iconColor: myPrimaryColor,
              onTap: () {
                box.write(StorageConstant.isLoggedIn, false);
                Get.offAll(() {
                  return LoginPage();
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Hi, ${box.read(StorageConstant.name)}"),
                      Icon(Icons.location_on),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: const Text("Add Family"))
                ],
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                  height: 150.0,
                  initialPage: 0,
                  autoPlay: true,
                  viewportFraction: 1,
                  enlargeCenterPage: true),
              items: [1].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.asset(
                      "assets/images/$i.png",
                      width: Get.width,
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BookTestChip(
                  heading: "BOOK A TEST",
                  label: "CLICK HEAR",
                  icon: Icons.arrow_forward,
                  onTap: () {
                    Get.to(BookTestPage());
                  },
                ),
                BookTestChip(
                  heading: "TEST HISTORY",
                  label: "CLICK HEAR",
                  icon: Icons.arrow_forward,
                  bgColor: Color(0xFF4feb8d),
                  onTap: () {
                    Get.to(TestHistoryPage());
                  },
                ),
              ],
            ),
            SizedBox(
              height: myHeightMedium,
            ),
            SizedBox(
              height: 210,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(top: -90, child: _buildRadialTextPointer()),
                  Positioned(
                      bottom: 0,
                      child: Text(
                        "Your Health Chart",
                        style: Get.theme.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
            Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: underWeight,
                                radius: 10,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Under Weight"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: good,
                                radius: 10,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Good"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: overWeight,
                                radius: 10,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Over Weight"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: obesity,
                                radius: 10,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Obesity"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            reportFound.isEmpty
                ? Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(2, 2))
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              color: myWhite,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Test Result $reportDate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Table(
                                        children:
                                            reportData.map((e) => e).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      reportFound.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Let's Join Organic Urine Mission to save nature",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              elevation: 8,
              color: myPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Refer Friend",
                  style: TextStyle(fontWeight: FontWeight.bold, color: myWhite),
                ),
              ),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.whatsappSquare,
                      color: Colors.green,
                      size: 28,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.facebookSquare,
                      size: 28,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.instagramSquare,
                      size: 28,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.share,
                      size: 28,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      MyChip(
                        imagePath: "assets/images/bmi.png",
                        name: "BMI",
                        onTap: () {
                          Get.to(BMIPage());
                        },
                      ),
                      MyChip(
                        imagePath: "assets/images/h2o.png",
                        name: "H2O",
                        onTap: () {
                          Get.to(WaterPage());
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      MyChip(
                        imagePath: "assets/images/footstep.png",
                        name: "STEPS",
                        onTap: () {
                          Get.to(StepCountPage());
                        },
                      ),
                      MyChip(
                        imagePath: "assets/images/sleep.png",
                        name: "SLEEP",
                        onTap: () {
                          Get.to(SleepCountPage());
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      MyChip(
                        imagePath: "assets/images/calories.png",
                        name: "CALORIE",
                        onTap: () {
                          Get.to(CalorieCountPage());
                        },
                      ),
                      MyChip(
                        imagePath: "assets/images/nutrition.png",
                        name: "NUTRITION",
                        onTap: () {
                          Get.to(NutritionCountPage());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double getBmi() {
    String height = box.read(StorageConstant.height);
    String weight = box.read(StorageConstant.height);
    int h = int.parse(height);
    int w = int.parse(weight);
    double v = w / ((h / 100) * (h / 100));
    print("BMI:: $w $h $v");
    if (v < 18.5) {
      return 22.5;
    } else if (v >= 18.5 && v < 24.9) {
      return 45;
    } else if (v >= 24.9 && v < 29.9) {
      return 75;
    } else {
      return 105;
    }
  }

  SfRadialGauge _buildRadialTextPointer() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showAxisLine: false,
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 360,
            maximum: 120,
            canScaleToFit: true,
            radiusFactor: 0.79,
            pointers: <GaugePointer>[
              NeedlePointer(
                  needleEndWidth: 5,
                  needleLength: 0.7,
                  value: getBmi(),
                  animationDuration: 3000,
                  enableAnimation: true,
                  knobStyle: KnobStyle(knobRadius: 0)),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 30,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.orange),
              GaugeRange(
                  startValue: 30.5,
                  endValue: 60,
                  startWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.45,
                  color: Colors.green),
              GaugeRange(
                  startValue: 60.5,
                  endValue: 90,
                  sizeUnit: GaugeSizeUnit.factor,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  color: Colors.red),
              GaugeRange(
                  startValue: 90.5,
                  endValue: 120,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.brown),
            ]),
        RadialAxis(
          showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 360,
          maximum: 120,
          radiusFactor: 0.85,
          canScaleToFit: true,
          pointers: <GaugePointer>[
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 15,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 45,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 75,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 105,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12)
          ],
        ),
      ],
    );
  }
}

class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.imagePath,
    required this.name,
    this.onTap,
    this.width,
    this.surfaceColor,
    this.nameSize,
  });
  final String? imagePath;
  final String? name;
  final double? nameSize;
  final double? width;
  final Color? surfaceColor;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GestureDetector(
          onTap: onTap ?? () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(2, 2))
              ],
              borderRadius: BorderRadius.circular(10),
              color: surfaceColor ?? myWhite,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: myPrimaryColor.withAlpha(20),
                  radius: 25,
                  child: Image.asset(
                    imagePath!,
                    width: width ?? 30,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  name!,
                  style: TextStyle(fontSize: nameSize ?? 14),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookTestChip extends StatelessWidget {
  const BookTestChip({
    super.key,
    required this.heading,
    required this.label,
    required this.icon,
    this.onTap,
    this.bgColor,
  });
  final String? heading;
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: myPaddingLarge, vertical: myPaddingMedium),
        decoration: BoxDecoration(
            color: bgColor ?? myAccentColor,
            borderRadius: BorderRadius.circular(myRadiusMedium)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading!,
              style: Get.theme.textTheme.headlineSmall!
                  .copyWith(fontSize: 20)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(label!),
                Icon(icon),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportResultModal {
  const ReportResultModal(
      {required this.name, required this.range, required this.value});
  final String? name;
  final String? range;
  final String? value;
}

class CustomListMenuItem extends StatelessWidget {
  CustomListMenuItem({
    Key? key,
    required this.name,
    required this.leadingIcon,
    required this.onTap,
    this.iconColor,
    this.iconSize = 35,
    this.leadingSpace = 20,
    this.textSize = 16,
    this.textColor = Colors.black87,
  }) : super(key: key);

  final String? name;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? textSize;
  final double? leadingSpace;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: Colors.grey.shade200))),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  leadingIcon,
                  size: iconSize,
                  color: iconColor ?? myWhite,
                ),
                SizedBox(
                  width: leadingSpace,
                ),
                Text(
                  name!,
                  style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
