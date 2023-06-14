import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/pages/nutrition_count_page.dart';
import 'package:susu/pages/water_pages.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/bim.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/order_detail_full_modal.dart';
import '../mywidgets/save_button_pdf_widget.dart';
import '../utils/mycontant.dart';
import '../utils/util.dart';
import 'bmi_page.dart';
import 'package:intl/intl.dart';

class ReportDetailPage extends StatefulWidget {
  final String? reportId;
  const ReportDetailPage({Key? key, required this.reportId}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  var userDetailFont =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  var gap = const SizedBox(
    height: 10,
  );
  List<TableRow> reportData = [];
  var box = GetStorage();
  var healthColor = Colors.green;
  var unHealthColor = Colors.orange.shade900;
  var toxicColor = Colors.red.shade900;
  var infectedColor = Colors.brown.shade900;
  bool walkBool = false;
  bool sleepBool = false;
  bool eatBool = false;
  bool drinkBool = false;
  bool nutritionBool = false;
  OrderDetailFullModal? orderDetailFullModal;
  int normal = 0;
  int bad = 0;
  String? bmi;
  double value = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportDetail();
  }

  Color getColorCode(int number) {
    if (number > 9) {
      return healthColor;
    } else if (number >= 6 && number <= 8) {
      return unHealthColor;
    } else if (number >= 3 && number <= 5) {
      return toxicColor;
    } else {
      return infectedColor;
    }
  }

  String getConditionText(int number) {
    if (number > 9) {
      value = 22.5;
      return "Healthy";
    } else if (number >= 6 && number <= 8) {
      value = 57.5;
      return "Unhealthy";
    } else if (number >= 3 && number <= 5) {
      value = 102.5;
      return "Toxic";
    } else {
      value = 150;
      return "Infected";
    }
  }

  void getConditionTextValue(int number) {
    setState(() {
      if (number > 9) {
        value = 22.5;
      } else if (number >= 6 && number <= 8) {
        value = 57.5;
      } else if (number >= 3 && number <= 5) {
        value = 102.5;
      } else {
        value = 162.5;
      }
    });
  }

  void reportDetail() {
    DashboardService.fetchReportDetailFull(widget.reportId.toString())
        .then((value) {
      if (value != null) {
        setState(() {
          orderDetailFullModal = value;

          if (orderDetailFullModal != null) {
            bmi = orderDetailFullModal?.orderDetail?.bmi;
            List<ReportDetail>? reportDetail =
                orderDetailFullModal!.reportDetail;

            if (reportDetail != null && reportDetail.isNotEmpty) {
              reportData.add(TableRow(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black45))),
                  children: [
                    tableCellHead("Description"),
                    tableCellHead("Range", true),
                    tableCellHead("Value", true),
                  ]));
              normal = 0;
              for (var element in reportDetail) {
                ReportDetail e = element;
                if ((e.condtion ?? "").toLowerCase() == "normal") {
                  normal++;
                }
                getConditionTextValue(normal);

                reportData.add(
                  TableRow(children: [
                    tableCell(e.fname, Colors.black87, false, true),
                    tableCell(e.alias, Colors.black87, true),
                    tableCell(
                        e.value,
                        (e.condtion ?? "").toLowerCase() == "normal"
                            ? Colors.green
                            : Colors.red,
                        true,
                        false),
                  ]),
                );
              }
            }
          }
        });
      }
    });
  }

  int getBmi() {
    String height = box.read(StorageConstant.height);
    String weight = box.read(StorageConstant.height);
    int h = int.parse(height);
    int w = int.parse(weight);
    double v = w / ((h / 100) * (h / 100));
    print("BMI:: Weight $w Height $h  BMI VALUE $v");
    return v.toInt();
  }

  int calculateAge({required DateTime fromDate}) {
    DateTime currentDate = fromDate;
    DateTime birthDate = DateTime.parse(box.read(StorageConstant.dob));
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
    print("Age $age");
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Detail"),
        actions: [
          if (orderDetailFullModal != null)
            SaveBtnBuilder(
                scheduledPicktimeStart: DateFormat("dd-MM-yyyy").format(
                    orderDetailFullModal!.orderDetail!.scheduledPicktimeStart!),
                age: calculateAge(
                        fromDate: orderDetailFullModal!
                            .orderDetail!.scheduledPicktimeStart!)
                    .toStringAsFixed(0),
                bmi: bmi,
                normal: normal,
                orderDetailFullModal: orderDetailFullModal),
          gapWidthM2
        ],
      ),
      body: SingleChildScrollView(
        child: orderDetailFullModal != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "User Profile",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "Date : ${DateFormat("dd-MM-yyyy").format(orderDetailFullModal!.orderDetail!.scheduledPicktimeStart!)}")
                            ],
                          ),
                          gap,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name : ${box.read(StorageConstant.name)}",
                                style: userDetailFont,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Age : ",
                                    style: userDetailFont,
                                  ),
                                  Text(
                                      "${calculateAge(fromDate: orderDetailFullModal!.orderDetail!.scheduledPicktimeStart!)} Yrs."),
                                ],
                              ),
                            ],
                          ),
                          gap,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Gender : ",
                                    style: userDetailFont,
                                  ),
                                  Text(box.read(StorageConstant.gender)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Weight :",
                                    style: userDetailFont,
                                  ),
                                  Text(
                                      "${box.read(StorageConstant.weight)} Kg"),
                                ],
                              ),
                            ],
                          ),
                          gap,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Height : ",
                                    style: userDetailFont,
                                  ),
                                  Text(
                                      "${box.read(StorageConstant.height)} cm"),
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                "BMI Score",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              gap,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (bmi != null)
                                    Container(
                                      alignment: Alignment.center,
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Text(
                                        bmi!,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  if (bmi != null)
                                    Text(
                                      BMI.getBmiExactTextByValue(bmi),
                                      style: const TextStyle(fontSize: 16),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Results",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            gap,
                            Table(
                              children: reportData.map((e) => e).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    gapHeightM2,
                    SizedBox(
                      height: 210,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            child: Column(
                              children: [
                                Text(
                                  "Performance Meter",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Divider(
                                    thickness: 3,
                                    color: myPrimaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: -70, child: _buildRadialTextPointer()),
                        ],
                      ),
                    ),
                    // Center(
                    //   child: Card(
                    //     color: getColorCode(normal).withAlpha(1),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Text(
                    //         getConditionText(normal),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: getColorCode(normal),
                    //             fontSize: 18),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.size.width * 0.15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: healthColor,
                                          radius: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Vitality"),
                                      ],
                                    ),
                                    gapHeightM1,
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: unHealthColor,
                                          radius: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Deviant"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: toxicColor,
                                          radius: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Unfit"),
                                      ],
                                    ),
                                    gapHeightM1,
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: infectedColor,
                                          radius: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        const Text("Lethal"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    gap,
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Training Guidelines",
                        style: Get.theme.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    )),
                    const Center(
                        child: SizedBox(
                      width: 50,
                      child: Divider(
                        color: Colors.green,
                        thickness: 2,
                      ),
                    )),

                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const IconChip(
                                      imagePath: "assets/images/footstep.png",
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                            "Walk up to ${box.read(StorageConstant.gender) == "female" ? 8000 : 10000} Steps"))
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      walkBool = !walkBool;
                                    });
                                  },
                                  icon: const Icon(Icons.info))
                            ],
                          ),
                          if (walkBool)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "You can really walk your way to fitness. Yet not sure! Don't worry, let's get started today."),
                                  gapHeightM1,
                                  const Text(
                                    "Know the benefits",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  gapHeightM1,
                                  const Text(
                                      "Physical activity doesn't need to be complicated. Something as simple as a daily brisk walk can help you live a healthier life."),
                                  gapHeightM1,
                                  const Text(
                                      "For example, regular brisk walking can help you:"),
                                  gapHeightM1,
                                  ...[
                                    "Maintain a healthy weight and lose body fat",
                                    "Prevent or manage various conditions, including heart disease, stroke, high blood pressure, cancer and type 2 diabetes",
                                    "Improve cardiovascular fitness",
                                    "Strengthen your bones and muscles",
                                    "Improve muscle endurance",
                                    "Increase energy levels",
                                    "Improve your mood, cognition, memory and sleep",
                                    "Improve your balance and coordination",
                                    "Strengthen immune system",
                                    "Reduce stress and tension"
                                  ].map((e) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: const CircleAvatar(
                                            radius: 3,
                                            backgroundColor: Colors.black87,
                                          ),
                                        ),
                                        gapWidthS,
                                        Flexible(child: Text(e))
                                      ],
                                    );
                                  })
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const IconChip(
                                      imagePath: "assets/images/sleep.png",
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                            "Sleep up to min ${Util.sleepByAge()} hours"))
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      sleepBool = !sleepBool;
                                    });
                                  },
                                  icon: const Icon(Icons.info))
                            ],
                          ),
                          if (sleepBool)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "Getting enough sleep has many benefits. It can help you to keep your mind and body healthy."),
                                  gapHeightM1,
                                  const Text(
                                    "Know the benefits",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  gapHeightM1,
                                  ...[
                                    "Get sick less often",
                                    "Lower your risk for serious health problems, like diabetes and heart disease Reduce stress and improve your mood",
                                    "Think more clearly and do better in school and at work",
                                    "Get along better with people",
                                    "Make good decisions and avoid injuries — for example, drowsy drivers cause thousands of car accidents every year",
                                  ].map((e) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: const CircleAvatar(
                                            radius: 3,
                                            backgroundColor: Colors.black87,
                                          ),
                                        ),
                                        gapWidthS,
                                        Flexible(child: Text(e))
                                      ],
                                    );
                                  })
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const IconChip(
                                imagePath: "assets/images/calories.png",
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                      "Eat up to ${Util.myBMR().toStringAsFixed(0)} Cal")),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      setState(() {
                                        eatBool = !eatBool;
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.info))
                            ],
                          ),
                          if (eatBool)
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: Get.width * 0.9,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: const [
                                                Text(
                                                  "Daily calorie intake based on activity level",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            gapHeightM2,
                                            Table(
                                              border: TableBorder.all(
                                                  color: Colors.black12),
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              columnWidths: const {
                                                0: FlexColumnWidth(5),
                                                1: FlexColumnWidth(3),
                                              },
                                              children: [
                                                TableRow(
                                                    decoration: BoxDecoration(
                                                        color: myPrimaryColor
                                                            .withOpacity(0.1)),
                                                    children: const [
                                                      TableCell(
                                                          child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "Activity Level",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )),
                                                      TableCell(
                                                          child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "Kcal Intake",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )),
                                                    ]),
                                                tableRow(
                                                    "Sedentary: little or no exercise",
                                                    1.2),
                                                tableRow(
                                                    "Exercise 1-3 times/week",
                                                    1.375),
                                                tableRow(
                                                    "Exercise 4-5 times/week",
                                                    1.55),
                                                tableRow(
                                                    "Daily exercise or intense exercise 3-4 times/week",
                                                    1.6),
                                                tableRow(
                                                    "Intense exercise 6-7 times/week",
                                                    1.725),
                                                tableRow(
                                                    "Very intense exercise daily, or physical job",
                                                    1.9),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                            text: const TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black54),
                                                children: [
                                              TextSpan(
                                                  text: "Exercise : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      "15-30 minutes of elevated heart rate activity.\n"),
                                              TextSpan(
                                                  text: "Intense exercise : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      "45-120 minutes of elevated heart rate activity.\n"),
                                              TextSpan(
                                                  text:
                                                      "Very intense exercise : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      "2+ hours of elevated heart rate activity."),
                                            ])),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const IconChip(
                                imagePath: "assets/images/h2o.png",
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                      "Drink up to min ${box.read(StorageConstant.gender) == "male" ? 3.5 : 3} Ltr water")),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      drinkBool = !drinkBool;
                                    });
                                  },
                                  icon: Icon(Icons.info))
                            ],
                          ),
                          if (drinkBool)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "Water is essential to most bodily functions."),
                                  gapHeightM1,
                                  const Text(
                                    "Know the benefits",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  gapHeightM1,
                                  ...[
                                    "Keep a normal temperature",
                                    "Lubricate and cushion joints.",
                                    "Protect your spinal cord and other sensitive tissues.",
                                    "Get rid of wastes through urination, perspiration, and bowel movements.",
                                  ].map((e) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: const CircleAvatar(
                                            radius: 3,
                                            backgroundColor: Colors.black87,
                                          ),
                                        ),
                                        gapWidthS,
                                        Flexible(child: Text(e))
                                      ],
                                    );
                                  })
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    gap,
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const IconChip(
                                imagePath: "assets/images/nutrition.png",
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Expanded(
                                  child:
                                      Text("Personalized nutrition expertise")),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      nutritionBool = !nutritionBool;
                                    });
                                  },
                                  icon: Icon(Icons.info))
                            ],
                          ),
                          if (nutritionBool)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "The development of human health is dependent mainly on nutrition."),
                                  gapHeightM1,
                                  const Text(
                                      "According to the adage, ‘You are what you eat’, people who eat well are healthier and more productive than those who don’t."),
                                  gapHeightM1,
                                  const Text(
                                      "Don't worry, our team of experts are always there to help you achieve your best goals, while analysing your body statistics from internally to externally."),
                                  gapHeightM1,
                                  Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(const NutritionCountPage());
                                        },
                                        child: const Text("Book Diet Chart")),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    gap,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Text(
                                "Importance Of Test Parameters - Why Is It Important?",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        gap,
                        showHeadDesc(
                            head: "Ketones",
                            desc:
                                "Ketones are chemicals that the body creates when it breaks down fat to use for energy. The body does this when it doesn't have enough glucose. Excessive production of ketones can also be a sign of an underlying health problem. So we will guide you the real time value for your daily physical activity"),
                        gap,
                        showHeadDesc(
                            head: "Bilirubin",
                            desc:
                                "Bilirubin is a yellowish substance made during your body's normal process of breaking down old red blood cells. It indicates the health of your liver. Higher levels of bilirubin may indicate weak body recovery level and may also indirectly affect the production of melatonin and disrupt the sleep wake cycle."),
                        gap,
                        showHeadDesc(
                            head: "Ph levels",
                            desc:
                                "Ph level is a measure of the Acidity or alkalinity in our body. A balanced nutrition diet is important to maintain the PH level of our body ie level 7"),
                        gap,
                        showHeadDesc(
                            head: "Specific gravity",
                            desc:
                                "Specific gravity is use to measure the concentration of substances in urine as well as other bodily fluid which provides information about the function of the kidneys and hydration levels."),
                        gap,
                        showHeadDesc(
                            head: "Glucose",
                            desc:
                                "Glucose is a simple sugar that is a primary source of energy for the cells in the human body. Maintaining normal glucose levels is important for heath and well being. Eating balance diet, exercising regularly & managing stress levels are some of the ways to help keep glucose levels"),
                        gap,
                        showHeadDesc(
                            head: "Urobilinogen (URO)",
                            desc:
                                """Our body produces urobilinogen when old red blood cells decompose, and bilirubin is one of the 
byproducts. When you have a high or low level of urobilinogen in your urine, that may indicate one or 
more liver conditions. 
Susu can guide you on keeping your liver healthy."""),
                        gap,
                        showHeadDesc(
                            head: "Proteinuria (Pro)",
                            desc:
                                """Having an excess of proteins in your urine is known as proteinuria (pro-TEE-NU-ree-uh). The 
presence of low levels of protein in urine is typical, while the presence of high levels is 
indicative of kidney disease.
Through SUSU, you will be able to generate a good amount of metabolic energy, which will be 
beneficial to protein intake and muscle growth."""),
                        gap,
                        showHeadDesc(
                            head: "Nitrogen (NIT)",
                            desc:
                                """An indicator of urine urea nitrogen is the presence of urea in the urine. During protein
breakdown, urea is produced as a waste product as an indicator of kidney efficiency and a 
measurement of how much protein your body consumes.
Your body will benefit from SUSU's nutritional guidance, so that you have an optimal amount of 
calories, proteins, and fats."""),
                        gap,
                        showHeadDesc(
                            head: "Leukocyte (LEU)",
                            desc:
                                """White blood cells, also known as leukocytes, are responsible for fighting germs in the body.
There is a possibility that an infection is manifested by the presence of higher levels of 
leukocytes in the urine.
Through Susu, you will improve your daily living activity, which improves your immune system."""),
                        gap,
                        showHeadDesc(
                            head: "Vitamin C (VC)",
                            desc:
                                """ Vitamin C is an antioxidant that aids in many bodily functions, such as digestion. In excessive 
amounts (more than 2,000 mg), it can cause diarrhoea and nausea.
SUSU provides nutrition advice that will help you maintain the right balance of vitamins and 
minerals in your body."""),
                        gap,
                        showHeadDesc(
                            head: "Blood (BLD)",
                            desc:
                                """A urinalysis is a test that determines whether you have blood in your urine, which indicates your 
general health as well as the health of your urinary tract, kidneys, and liver."""),
                      ]),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  TableRow tableRow(String title, double rowValue) {
    return TableRow(children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
      ),
      TableCell(
        child: Center(
          child: Text((Util.myBMR() * rowValue).toStringAsFixed(0)),
        ),
      ),
    ]);
  }

  Column showHeadDesc({String? head, String? desc}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head!,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        Text(desc!, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  SfRadialGauge _buildRadialTextPointer() {
    var isCardView = true;

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showAxisLine: false,
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 360,
            maximum: 180,
            canScaleToFit: true,
            radiusFactor: 0.79,
            pointers: <GaugePointer>[
              NeedlePointer(
                  needleEndWidth: 5,
                  needleLength: 0.7,
                  value: value,
                  animationDuration: 3000,
                  enableAnimation: true,
                  knobStyle: KnobStyle(knobRadius: 0)),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 45,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: healthColor),
              GaugeRange(
                  startValue: 45.5,
                  endValue: 90,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: unHealthColor),
              GaugeRange(
                  startValue: 90.5,
                  endValue: 135,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: toxicColor),
              GaugeRange(
                  startValue: 135.5,
                  endValue: 180,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: infectedColor),
            ]),
        RadialAxis(
          showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 360,
          maximum: 180,
          radiusFactor: 0.85,
          canScaleToFit: true,
          pointers: <GaugePointer>[
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 22.5,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 65.5,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 111.5,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isCardView ? 14 : 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 162.5,
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

  TableCell tableCell(name, Color range, [bool? center, bool bold = false]) =>
      TableCell(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: center != null && center
                  ? Center(
                      child: Text(
                      name,
                      style: TextStyle(
                          color: range,
                          fontWeight:
                              bold ? FontWeight.bold : FontWeight.normal),
                    ))
                  : Text(
                      name,
                      style: TextStyle(
                          color: range,
                          fontWeight:
                              bold ? FontWeight.bold : FontWeight.normal),
                    )));

  TableCell tableCellHead(String name, [bool? center, bool bold = false]) =>
      TableCell(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: center != null && center
            ? Center(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      ));
}

class IconChip extends StatelessWidget {
  const IconChip({
    super.key,
    this.imagePath,
  });
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 60,
        width: 60,
        child: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Image.asset(
              imagePath!,
              width: 40,
            )),
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 5),
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
            child: Column(
              children: [
                Image.asset(
                  imagePath!,
                  width: width ?? 50,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  name!,
                  style: TextStyle(
                      fontSize: nameSize ?? 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
