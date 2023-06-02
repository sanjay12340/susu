import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/models/order_detail_full_modal.dart';
import 'package:susu/pages/bmi_page.dart';
import 'package:susu/pages/calorie_count_page.dart';
import 'package:susu/pages/report_detail_page.dart';
import 'package:susu/pages/sleep_count_page.dart';
import 'package:susu/pages/step_count_page.dart';
import 'package:susu/pages/water_pages.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:susu/extentions/my_string.dart';
import 'package:susu/utils/util.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../utils/bim.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var box = GetStorage();
  String? name;
  bool isCardView = true;
  String reportFound = "Wait..";
  String reportDate = "";
  var lastReport = List<ReportResultModal>.empty(growable: true);
  String orderId = "";

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
              orderId = e['order_id'];
              print("$e['name'] and alise $e['alise']");
              reportData.add(
                TableRow(children: [
                  tableCell(e['fname'], Colors.black87, true, true),
                  tableCell(e['alise'], Colors.black87, true),
                  tableCell(
                      e['value'],
                      (e["p_condition"] ?? "").toLowerCase() == "normal"
                          ? Colors.green
                          : Colors.red,
                      true),
                ]),
              );
            }
          }
        });
      } else {
        setState(() {
          reportFound = "Recent test result not found";
        });
      }
    });
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
        child: Center(
          child: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
    );
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHeightL2,
              Text(
                "Welcome Back",
                style: TextStyle(color: Colors.black54),
              ),
              Text(
                box.read(StorageConstant.name).toString(),
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
              gapHeightL2,
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 150,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(colors: [
                            Color(0xFF7ec5dc),
                            Color(0xFF21a974),
                          ])),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 20,
                      child: Text.rich(TextSpan(
                          style: TextStyle(
                              color: myWhite, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: "BMI (Body Mass Index)",
                                style: TextStyle(fontSize: 18)),
                            TextSpan(
                                text:
                                    "\n${BMI.getBmiExactText(height: int.parse(box.read(StorageConstant.height)), weight: int.parse(box.read(StorageConstant.weight)))}")
                          ]))),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: Image.asset(
                        "assets/images/dial.png",
                        width: 130,
                      )),
                  Positioned(
                    top: 38,
                    right: 42,
                    child: Text(
                      BMI
                          .getBmiExact(
                              height:
                                  int.parse(box.read(StorageConstant.height)),
                              weight:
                                  int.parse(box.read(StorageConstant.weight)))
                          .toStringAsFixed(0),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myWhite),
                    ),
                  ),
                  Positioned(
                      bottom: 25,
                      left: 42,
                      child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            Get.to(BMIPage());
                          },
                          child: Text("View More"))),
                ],
              ),
              gapHeightM2,
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(4),
                                              1: FlexColumnWidth(4),
                                              2: FlexColumnWidth(2),
                                            },
                                            border: TableBorder.all(
                                                color: Colors.black12),
                                            children: reportData
                                                .map((e) => e)
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                        style: buttonStyle,
                                        onPressed: () {
                                          Get.to(ReportDetailPage(
                                            reportId: orderId,
                                          ));
                                        },
                                        child: Text("View Report")),
                                    gapHeightM2,
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
              gapHeightM2,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recommended Training Statistics",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              gapHeightM2,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  taskCard("Water intake", "water.png",
                      "${box.read(StorageConstant.gender) == "male" ? 3.5 : 3} Liter",
                      () {
                    Get.to(WaterPage());
                  }),
                  taskCard("Sleep", "sleep.png", "${Util.sleepByAge()} Hours",
                      () {
                    Get.to(SleepCountPage());
                  }),
                ],
              ),
              gapHeightM2,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  taskCard("Step", "footstep.png",
                      "${box.read(StorageConstant.gender) == "female" ? 8000 : 10000} Steps",
                      () {
                    Get.to(StepCountPage());
                  }),
                  taskCard("kcal Intake", "calories.png",
                      "${Util.myBMR().toStringAsFixed(0)} cal", () {
                    Get.to(CalorieCountPage());
                  }),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  double getBmi() {
    return BMI.getBmi(
        height: int.parse(box.read(StorageConstant.height)),
        weight: int.parse(box.read(StorageConstant.weight)));
  }

  SfRadialGauge _buildRadialTextPointer() {
    var isCardView = false;
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

Widget taskCard(
    String name, String image, String task, void Function()? onTop) {
  return GestureDetector(
    onTap: onTop,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: Get.width * 0.45,
      constraints: BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: myWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapHeightS,
          Text(
            name,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              task,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade400),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/images/$image",
              height: 40,
            ),
          )
        ],
      ),
    ),
  );
}

class ReportResultModal {
  const ReportResultModal(
      {required this.name, required this.range, required this.value});
  final String? name;
  final String? range;
  final String? value;
}
