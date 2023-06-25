import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:susu/pages/Login.dart';
import 'package:susu/pages/bmi_page.dart';
import 'package:susu/pages/book_test_page.dart';
import 'package:susu/pages/calorie_count_page.dart';
import 'package:susu/pages/dashboard_page.dart';
import 'package:susu/pages/info_page.dart';
import 'package:susu/pages/nutrition_count_page.dart';
import 'package:susu/pages/report_detail_page.dart';
import 'package:susu/pages/sleep_count_page.dart';
import 'package:susu/pages/step_count_page.dart';
import 'package:susu/pages/test_history_page.dart';
import 'package:susu/pages/water_pages.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/bim.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';

import '../notificationservice/local_notification_service.dart';
import '../utils/util.dart';
import 'account_page.dart';
import 'contact_info_change_password.dart';

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
  double _sliderValue = 0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print("New Notification");
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    fetchLatestReport();
  }

  String? subscriptionDaysLeft() {
    print("days check  ${box.read(StorageConstant.next_date)}");
    if (box.read(StorageConstant.userStatus) != null &&
        box.read(StorageConstant.userStatus) == false) {
      return "Profile: Locked";
    }
    if (box.read(StorageConstant.next_date) != null) {
      DateTime currentDate = DateTime.now();
      DateTime nextDate =
          DateFormat('yyyy-MM-dd').parse(box.read(StorageConstant.next_date));
      int days = nextDate.difference(currentDate).inDays;
      return "Subscription Days Left : ${days}";
    }
    return "Subscription Days Left : Locked";
  }

  int? nextBookingDays() {
    if (box.read(StorageConstant.next_date) != null) {
      DateTime currentDate = DateTime.now();
      DateTime nextDate =
          DateFormat('yyyy-MM-dd').parse(box.read(StorageConstant.next_date));
      int days = nextDate.difference(currentDate).inDays;
      return days;
    }
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
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black45))),
              children: [
                tableCellHead("Name"),
                tableCellHead("Range", true),
                tableCellHead("Value", true),
              ]));
          List<dynamic> rd = value['data'];
          print(rd);

          for (var element in rd) {
            Map<String, dynamic> e = element;
            if (e['name'] == "VC" ||
                e['name'] == "NIT" ||
                e['name'] == "GLU" ||
                e['name'] == "SG" ||
                e['name'] == "BIL") {
              print("$e['name'] and alise $e['alise']");
              reportData.add(
                TableRow(children: [
                  tableCell(e['name'], true, true),
                  tableCell(e['alias'], true),
                  tableCell(e['value'], true),
                ]),
              );
            }
          }
        });
      } else {
        Map<String, dynamic> user = value['user'];
        Util.storeValueOfUser(user);
        // print("Next Date" + box.read(StorageConstant.next_date));
        setState(() {
          reportFound = "Recent test result not found";
        });
      }
    });
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
        child: Center(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ));
  void goTO(Widget goTo) {
    _key.currentState!.openEndDrawer();
    Get.to(() => goTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text(
          "SUSU",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [],
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                          "assets/images/${box.read(StorageConstant.gender) == "male" ? 'male' : 'female'}.png",
                          width: 70),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            box.read("name"),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            box.read("username"),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Credit : ${box.read(StorageConstant.point) ?? 0.toString()}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${subscriptionDaysLeft()}",
                            style: const TextStyle(
                              fontSize: 14,
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
              name: "Change Password",
              leadingIcon: Icons.key,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(ContactInfoPagePassword());
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
        child: SizedBox(
          width: Get.size.width,
          height: Get.height - 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shadowColor: myPrimaryColor,
              child: Column(
                children: [
                  gapHeightM2,
                  Text(
                    box.read(StorageConstant.name),
                    style: TextStyle(
                        fontSize: 30,
                        color: myPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      width: 50,
                      child: Divider(
                        color: myPrimaryColor,
                        thickness: 2,
                      )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        circleButton(
                          name: "Book Now",
                          startColor: const Color(0xFF75b6b2),
                          endColor: const Color(0xFF3f618f),
                          onTap: () {
                            print(
                                "Next date ::: ${box.read(StorageConstant.next_date)}");

                            var difference = 0;
                            bool flag = !box.read(StorageConstant.userStatus);
                            bool profileLock = flag;
                            if (box.read(StorageConstant.next_date) != null) {
                              var inputFormat = DateFormat('yyyy-MM-dd');
                              var orderDate = inputFormat
                                  .parse(box.read(StorageConstant.next_date));

                              final date2 = DateTime.now();
                              difference = orderDate.difference(date2).inDays;
                              print("difference ${difference}");
                            }
                            if (flag && difference <= 0) {
                              Get.dialog(Dialog(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  width: 250,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipPath(
                                            clipper: LeftBottomClipper(),
                                            child: Container(
                                              height: 150,
                                              color: myPrimaryColor,
                                            ),
                                          ),
                                          Positioned(
                                              top: 15,
                                              right: 15,
                                              child: Image.asset(
                                                "assets/images/book_now.png",
                                                width: 125,
                                              )),
                                        ],
                                      ),
                                      Text(
                                        "Free Test",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Once you confirm your booking, a trained Phlebotomists (Sample Collector) will be assigned to visit you on your chosen time and pickup address and for collection of sample. ",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      gapHeightS,
                                      ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            Get.to(BookTestPage());
                                          },
                                          child: Text("Book Now")),
                                      gapHeightS,
                                    ],
                                  ),
                                ),
                              ));
                            } else {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText:
                                      "You are already enrolled as our prestigious monthly member.\n\nUsers are allowed to book their tests once a month only.${profileLock ? "\ndays Left : ${difference >= 0 ? difference : '0'}" : ''}");
                            }
                          },
                        ),
                        circleButton(
                          name: "Your Report",
                          startColor: const Color(0xFFa0538b),
                          endColor: const Color(0xFF634d8d),
                          onTap: () {
                            if (box.read(StorageConstant.userStatus) != null &&
                                box.read(StorageConstant.userStatus)) {
                              Get.dialog(Dialog(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      width: 250,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    top: 50,
                                                    child: Image.asset(
                                                      "assets/images/calendar_group.png",
                                                      fit: BoxFit.cover,
                                                    )),
                                                ClipPath(
                                                  clipper: LeftBottomClipper(),
                                                  child: Container(
                                                    height: 150,
                                                    color: myPrimaryColor,
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 15,
                                                    right: 15,
                                                    child: Image.asset(
                                                      "assets/images/calendar.png",
                                                      width: 125,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          gapHeightM2,
                                          Text("Please Select Date"),
                                          gapHeightM2,
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.black38)),
                                            onPressed: () {

                                              // showMonthPicker(
                                              // context: context,
                                              // initialDate: DateTime.now(),
                                              // firstDate: DateTime(1970),
                                              // lastDate: DateTime(2050)
                                              // );
                                              showMonthPicker(
                                                context: context,
                                                headerColor: myPrimaryColor,
                                                initialDate: DateTime.now(),
                                              ).then((date) {
                                                if (date != null) {
                                                  setState(() {
                                                    selectedDate = date;
                                                  });
                                                }
                                              });
                                            },
                                            child: Container(
                                              child: Text(
                                                DateFormat("MMM yyyy")
                                                    .format(selectedDate),
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ),
                                          ),
                                          gapHeightM2,
                                          ElevatedButton(
                                              onPressed: () {
                                                DashboardService
                                                        .fetchReportDetailFullByMonth(
                                                            DateFormat(
                                                                    "MM-yyyy")
                                                                .format(
                                                                    selectedDate))
                                                    .then((value) {
                                                  if (value != null) {
                                                    Get.back();
                                                    if (value.status!) {
                                                      if (value.orderDetail!
                                                              .status! ==
                                                          "completed") {
                                                        if (value.orderDetail!
                                                                .locked ==
                                                            "0") {
                                                          Get.to(
                                                              ReportDetailPage(
                                                            reportId: value
                                                                .orderDetail!
                                                                .id!,
                                                          ));
                                                        } else if (int.parse(box
                                                                .read(StorageConstant
                                                                    .point)) <
                                                            30) {
                                                          Get.to(InfoPage());
                                                        } else {
                                                          Get.to(
                                                              ReportDetailPage(
                                                            reportId: value
                                                                .orderDetail!
                                                                .id!,
                                                          ));
                                                        }
                                                      } else if (value
                                                              .orderDetail!
                                                              .status! !=
                                                          "completed") {
                                                        Get.defaultDialog(
                                                            title: "Alert",
                                                            middleText:
                                                                "Your report is under process");
                                                      }
                                                    } else {
                                                      Get.defaultDialog(
                                                          title: "Alert",
                                                          middleText:
                                                              "No Record Found");
                                                    }
                                                  } else {
                                                    Get.defaultDialog(
                                                        title: "Alert",
                                                        middleText:
                                                            "No Record Found");
                                                  }
                                                });
                                              },
                                              child: const Text("Continue")),
                                          gapHeightM2,
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ));
                            } else {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText: """Your profile is locked for now.

You have to Book Test first, then wait until your final lab results are evaluated. After this only, you would be able to unlock your report and access your personalized dashboard.

Team Susu""");
                            }
                          },
                        ),
                        circleButton(
                          name: "Your Training",
                          name2: "Program",
                          startColor: const Color(0xFFffc49f),
                          endColor: const Color(0xFFf679a1),
                          onTap: () {
                            if (box.read(StorageConstant.userStatus)) {
                              Get.dialog(Dialog(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  width: 250,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                top: 50,
                                                child: Text("Traning Program")),
                                            ClipPath(
                                              clipper: LeftBottomClipper(),
                                              child: Container(
                                                height: 150,
                                                color: myPrimaryColor,
                                              ),
                                            ),
                                            Positioned(
                                                top: 15,
                                                right: 15,
                                                child: Card(
                                                  child: Image.asset(
                                                    "assets/images/report.png",
                                                    width: 100,
                                                  ),
                                                )),
                                            Positioned(
                                                top: 45,
                                                left: 15,
                                                child: Text(
                                                  "Training Guide",
                                                  style: TextStyle(
                                                      color: myWhite,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              trainingItem("bmi.png", "BMI",
                                                  () {
                                                Get.to(BMIPage());
                                              }),
                                              trainingItem("water.png", "Water",
                                                  () {
                                                Get.to(WaterPage());
                                              }),
                                            ],
                                          ),
                                          gapHeightM2,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              trainingItem(
                                                  "nutrition.png", "Nutrition",
                                                  () {
                                                Get.to(NutritionCountPage());
                                              }),
                                              trainingItem("sleep.png", "Sleep",
                                                  () {
                                                Get.to(SleepCountPage());
                                              }),
                                            ],
                                          ),
                                          gapHeightM2,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              trainingItem(
                                                  "calories.png", "kcal Intake",
                                                  () {
                                                Get.to(CalorieCountPage());
                                              }),
                                              trainingItem(
                                                  "footstep.png", "Kcal Burn",
                                                  () {
                                                Get.to(StepCountPage());
                                              }),
                                            ],
                                          ),
                                        ],
                                      ),
                                      gapHeightM2,
                                    ],
                                  ),
                                ),
                              ));
                            } else {
                              DashboardService.fetchReportDetailFullByMonth(
                                      DateFormat("MM-yyyy")
                                          .format(DateTime.now()))
                                  .then((value) {
                                if (value != null) {
                                  if (value.status!) {
                                    if (value.orderDetail!.status! ==
                                        "completed") {
                                      if (int.parse(box
                                              .read(StorageConstant.point)) >=
                                          30) {
                                        DashboardService.saveUpdatePoints(
                                                30, false)
                                            .then((value) {
                                          box.write(
                                              StorageConstant.point,
                                              (int.parse(box.read(
                                                          StorageConstant
                                                              .point)) -
                                                      30)
                                                  .toString());
                                          box.write(
                                              StorageConstant.userStatus, true);
                                          setState(() {});
                                          Get.dialog(Dialog(
                                            clipBehavior: Clip.hardEdge,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Container(
                                              width: 250,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 150,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                            top: 50,
                                                            child: Text(
                                                                "Traning Program")),
                                                        ClipPath(
                                                          clipper:
                                                              LeftBottomClipper(),
                                                          child: Container(
                                                            height: 150,
                                                            color:
                                                                myPrimaryColor,
                                                          ),
                                                        ),
                                                        Positioned(
                                                            top: 15,
                                                            right: 15,
                                                            child: Card(
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/report.png",
                                                                width: 100,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          trainingItem(
                                                              "bmi.png", "BMI",
                                                              () {
                                                            Get.back();
                                                            Get.to(BMIPage());
                                                          }),
                                                          trainingItem(
                                                              "water.png",
                                                              "Water", () {
                                                            Get.back();
                                                            Get.to(WaterPage());
                                                          }),
                                                        ],
                                                      ),
                                                      gapHeightM2,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          trainingItem(
                                                              "nutrition.png",
                                                              "Nutrition", () {
                                                            Get.back();
                                                            Get.to(
                                                                NutritionCountPage());
                                                          }),
                                                          trainingItem(
                                                              "sleep.png",
                                                              "Sleep", () {
                                                            Get.back();
                                                            Get.to(
                                                                SleepCountPage());
                                                          }),
                                                        ],
                                                      ),
                                                      gapHeightM2,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          trainingItem(
                                                              "calories.png",
                                                              "kcal Intake",
                                                              () {
                                                            Get.back();
                                                            Get.to(
                                                                CalorieCountPage());
                                                          }),
                                                          trainingItem(
                                                              "footstep.png",
                                                              "Step", () {
                                                            Get.back();
                                                            Get.to(
                                                                StepCountPage());
                                                          }),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  gapHeightM2,
                                                ],
                                              ),
                                            ),
                                          ));
                                        });
                                      } else {
                                        Get.to(InfoPage());
                                      }
                                    } else if (value.orderDetail!.status! ==
                                            "pending" ||
                                        value.orderDetail!.status! ==
                                            "captured") {
                                      Get.defaultDialog(
                                          title: "Alert",
                                          middleText:
                                              "Your test is under process");
                                    }
                                  } else {
                                    Get.defaultDialog(
                                        title: "Alert",
                                        middleText: "Please Book your Test");
                                  }
                                } else {
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText: "Please Book your Test");
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Refer"),
                      IconButton(
                        onPressed: () {
                          try {
                            Share.shareWithResult("Share Link").then((value) {
                              print(
                                  "Reffer:: status ${value.status} ShareResultStatus.success  ${value == ShareResultStatus.success} ShareResultStatus.dismissed ${value == ShareResultStatus.dismissed} ShareResultStatus.unavailable ${value == ShareResultStatus.unavailable} values ${ShareResultStatus.values.toString()}");
                              if (value.status == ShareResultStatus.success) {
                                DashboardService.saveUpdatePoints(10, true);

                                box.write(
                                    StorageConstant.point,
                                    (int.parse(box
                                                .read(StorageConstant.point)) +
                                            10)
                                        .toString());
                                setState(() {});
                              }
                            });
                          } catch (e) {
                            print("Reffer:: Catch $e");
                          }
                        },
                        icon: const Icon(
                          FontAwesomeIcons.share,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (box.read(StorageConstant.userStatus)) {
                          Get.to(DashboardPage());
                        } else {
                          DashboardService.fetchReportDetailFullByMonth(
                                  DateFormat("MM-yyyy").format(DateTime.now()))
                              .then((value) {
                            if (value != null) {
                              if (value.status!) {
                                print("Dasboard ${value.orderDetail!.status!}");
                                if (value.orderDetail!.status! == "completed") {
                                  if (int.parse(
                                          box.read(StorageConstant.point)) >=
                                      30) {
                                    DashboardService.saveUpdatePoints(30, false)
                                        .then((value) {
                                      box.write(
                                          StorageConstant.point,
                                          (int.parse(box.read(
                                                      StorageConstant.point)) -
                                                  30)
                                              .toString());
                                      box.write(
                                          StorageConstant.userStatus, true);
                                      setState(() {});
                                      Get.to(DashboardPage());
                                    });
                                  } else {
                                    print("Else First");
                                    Get.to(InfoPage());
                                  }
                                } else if (value.orderDetail!.status! ==
                                        "pending" ||
                                    value.orderDetail!.status! == "captured") {
                                  print("Else First");
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText:
                                          "Your report is under process");
                                } else if (value.orderDetail!.status! !=
                                    "completed") {
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText:
                                          "Your report is under process");
                                }
                              } else {
                                Get.defaultDialog(
                                    title: "Alert",
                                    middleText: "Please Book your Test");
                              }
                            } else {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText: "Please Book your Test");
                            }
                          });
                        }
                      },
                      child: Text("Dashboard")),
                  gapHeightL2,
                  gapHeightM2,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector trainingItem(String image,
      [String? name, void Function()? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(color: myPrimaryColor, offset: Offset(3, 3))
                ]),
            child: SizedBox(
              width: 15,
              height: 15,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    "assets/images/$image",
                  ),
                ),
              ),
            ),
          ),
          if (name != null)
            Column(
              children: [
                gapHeightS,
                Text(name),
              ],
            )
        ],
      ),
    );
  }

  Widget circleButton(
      {required String name,
      String? name2,
      required Color startColor,
      required Color endColor,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: myWhite,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [startColor, endColor])),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: myWhite, decoration: TextDecoration.underline),
                ),
                if (name2 != null)
                  Text(
                    name2,
                    style: TextStyle(color: myWhite),
                  )
              ],
            )),
          ),
        ),
      ),
    );
  }

  double getBmi() {
    return BMI.getBmi(
        height: int.parse(box.read(StorageConstant.height)),
        weight: int.parse(box.read(StorageConstant.weight)));
  }

  SfSliderTheme _numerical() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            tooltipBackgroundColor: myPrimaryColor,
            labelOffset: const Offset(-30, 0),
            tickOffset: const Offset(-15, 0)),
        child: SfSlider.vertical(
          showLabels: true,
          interval: 10,
          min: 0.0,
          max: 13.0,
          showTicks: true,
          isInversed: true,
          tooltipPosition: SliderTooltipPosition.right,
          value: _sliderValue,
          onChanged: (dynamic values) {},
          enableTooltip: true,
          shouldAlwaysShowTooltip: false,
        ));
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
                  knobStyle: const KnobStyle(knobRadius: 0)),
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

class LeftBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 50);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                const SizedBox(
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
        padding: const EdgeInsets.symmetric(
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
                const SizedBox(
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
