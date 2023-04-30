import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/pages/water_pages.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/order_detail_full_modal.dart';
import '../utils/mycontant.dart';
import 'bmi_page.dart';
import 'package:intl/intl.dart';

class ReportDetailPage extends StatefulWidget {
  final String? reportId;
  const ReportDetailPage({Key? key, required this.reportId}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  var userDetailFont = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  var gap = SizedBox(
    height: 10,
  );
  List<TableRow> reportData = [];
  var box = GetStorage();
  var healthColor = Colors.green;
  var unHealthColor = Colors.orange.shade900;
  var toxicColor = Colors.red.shade900;
  var infectedColor = Colors.brown.shade900;
  OrderDetailFullModal? orderDetailFullModal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportDetail();
  }

  void reportDetail() {
    DashboardService.fetchReportDetailFull(widget.reportId.toString())
        .then((value) {
      if (value != null) {
        setState(() {
          orderDetailFullModal = value;
          if (orderDetailFullModal != null) {
            List<ReportDetail>? reportDetail =
                orderDetailFullModal!.reportDetail;
            if (reportDetail != null && reportDetail.isNotEmpty) {
              reportData.add(TableRow(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black45))),
                  children: [
                    tableCellHead("Description"),
                    tableCellHead("Range", true),
                    tableCellHead("Value", true),
                  ]));

              for (var element in reportDetail) {
                ReportDetail e = element;
                reportData.add(
                  TableRow(children: [
                    tableCell(e.name, false, true),
                    tableCell(e.alise, true),
                    tableCell(e.value, true),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Detail")),
      body: SingleChildScrollView(
        child: orderDetailFullModal != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "User Profile",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
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
                                  Text("20 Yrs."),
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
                              Text(
                                "BMI Score",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              gap,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text(
                                      getBmi().toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Bad",
                                    style: TextStyle(fontSize: 22),
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
                                Text(
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
                    SizedBox(
                      height: 300,
                      child: SvgPicture.asset(
                        box.read(StorageConstant.gender) == "male"
                            ? "assets/images/male.svg"
                            : "assets/images/female.svg",
                        color: Colors.red,
                      ),
                    ),
                    Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    Text("Healthy"),
                                  ],
                                ),
                                gap,
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: unHealthColor,
                                      radius: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Unhealthy"),
                                  ],
                                ),
                              ],
                            ),
                            gap,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    Text("Toxic"),
                                  ],
                                ),
                                gap,
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: infectedColor,
                                      radius: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Infected"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    gap,
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Nutritional Guidelines",
                        style: Get.theme.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    )),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconChip(
                                imagePath: "assets/images/footstep.png",
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("Walk up to 3000 Steps"))
                            ],
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconChip(
                                imagePath: "assets/images/sleep.png",
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("Sleep up to min 7-8 Hrs"))
                            ],
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconChip(
                                imagePath: "assets/images/nutrition.png",
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("Eat up to 1500 Cal"))
                            ],
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconChip(
                                imagePath: "assets/images/h2o.png",
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text("Drink up to min 3 Ltr water"))
                            ],
                          ),
                        ],
                      ),
                    ),
                    gap,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        Row(
                          children: [
                            Flexible(
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
                      ]),
                    )
                  ],
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Column showHeadDesc({String? head, String? desc}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head!,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Text(desc!, style: TextStyle(color: Colors.black54)),
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
            pointers: const <GaugePointer>[
              NeedlePointer(
                  needleEndWidth: 5,
                  needleLength: 0.7,
                  value: 80,
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
            padding: EdgeInsets.symmetric(vertical: 5),
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
                SizedBox(
                  height: 5,
                ),
                Text(
                  name!,
                  style: TextStyle(
                      fontSize: nameSize ?? 16, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
