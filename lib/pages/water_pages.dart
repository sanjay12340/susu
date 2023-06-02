import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/water_history_detail_modal.dart';
import '../utils/mycontant.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  int todayGlassTaken = 0;
  int todayGlassTakenFull = 0;
  int maxGlass = 18;
  final double _size = 100;
  double _value = 0;
  var lastReport = List<ReportResultModal>.empty(growable: true);
  Widget _downloadImage = Container(
    height: 40,
    width: 40,
    child: Image.asset("assets/images/water.png"),
  );
  var box = GetStorage();
  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  void fetchDetail() {
    DashboardService.fetchWaterReport(box.read(StorageConstant.id), 8)
        .then((value) {
      if (value != null) {
        List<Today>? history = value.history;
        Today? today = value.today;
        DateTime? lastOrderDate = today?.lastOrderDate;
        if (kDebugMode) {
          print("Last Order Date ${today?.lastOrderDate}");
        }
        setState(() {
          if (today != null) {
            maxGlass = today.goal != null ? int.parse(today.goal!) : 13;
            todayGlassTakenFull = todayGlassTaken =
                today.glass != null ? int.parse(today.glass!) : 0;
            double per = (todayGlassTaken * 100) / maxGlass;
            if (per <= 100) {
              _value = per;
            } else {
              _value = 100;
            }
            if (per <= 0) {
              _value = 0;
            }
          }
          if (history != null && lastOrderDate != null) {
            print("Format date in history");
            DateTime now = DateTime.now();

            DateFormat dateFormat = DateFormat('yyyy-MM-dd');
            DateFormat dateFinal = DateFormat('dd MMM yyyy');

            for (int i = 1; i <= 7; i++) {
              DateTime date = now.subtract(Duration(days: i));
              String formattedDate = dateFormat.format(date);
              Today? t = history.firstWhereOrNull((element) =>
                  dateFormat.format(element.date!) == formattedDate);
              String? glass = t?.glass;
              var lastOrderDays = lastOrderDate.difference(date).isNegative;
              print(
                  "date Compare current date ${dateFormat.format(date)}  last date  ${dateFormat.format(lastOrderDate)} diffrance ${lastOrderDays} ");
              if (lastOrderDays) {
                lastReport.add(ReportResultModal(
                    name: dateFinal.format(date),
                    range: t?.goal.toString() ?? maxGlass.toString(),
                    value: "${glass ?? 0} Glass"));
              }

              if (kDebugMode) {
                print("today ::: ${t?.toJson()}");
                print("Format date $formattedDate");
              }
            }
          }
        });
      } else {
        print("else History:::: $value");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Water"),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Drink Water",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getFourthProgressBar(),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                int f = todayGlassTaken + 1;
                                todayGlassTakenFull = f;
                                DashboardService.saveWaterIntake(
                                    glass: 1,
                                    userId: box.read(StorageConstant.id));
                                // if (maxGlass <= f) {
                                //   print("maxStep $f");
                                //   f = maxGlass;
                                // }
                                if (f <= 0) {
                                  f = 0;
                                }
                                todayGlassTaken = f;
                                double per = (todayGlassTaken * 100) / maxGlass;
                                if (per <= 100) {
                                  _value = per;
                                } else {
                                  _value = 100;
                                }
                                if (per <= 0) {
                                  _value = 0;
                                }
                              });
                            },
                            icon: Icon(Icons.add_circle_outlined)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "1 Glass 300 ml",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Today Goal ${maxGlass}, Taken ${todayGlassTakenFull}  Glass",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Today Tips",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey.shade200,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset("assets/images/water.png"),
                        ),
                        const Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "when you are trying to lose weight drink if you glass of water about 30 minutes before a meal.  This will come to the hydrate the tissues and can also lower the amount of food consumed",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 0,
              child: Column(
                children: [
                  Container(
                    height: 220,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
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
                                  "Daily Water intake",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: DataTable2(
                                checkboxHorizontalMargin: 0,
                                headingRowHeight: 33,
                                columnSpacing: 0,
                                bottomMargin: 0,
                                headingRowColor: MaterialStateProperty.all(
                                    Colors.green.withAlpha(100)),
                                border: TableBorder.all(
                                    color: Colors.grey.shade200),
                                columns: [
                                  DataColumn2(
                                    label: Center(child: Text('Date')),
                                  ),
                                  DataColumn2(
                                    label: Center(child: Text('Goal')),
                                  ),
                                  DataColumn2(
                                    label: Center(child: Text('Intake')),
                                  ),
                                ],
                                rows: lastReport
                                    .map((e) => DataRow(cells: [
                                          DataCell(
                                              Center(child: Text(e.name!))),
                                          DataCell(
                                              Center(child: Text(e.range!))),
                                          DataCell(
                                              Center(child: Text(e.value!))),
                                        ]))
                                    .toList()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setValue({String? direction, double? value}) {
    if (direction == "up") {}
  }

  Widget _getFourthProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 1,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.15,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                  value: _value,
                  width: 0.15,
                  sizeUnit: GaugeSizeUnit.factor,
                  enableAnimation: true,
                  animationDuration: 20,
                  animationType: AnimationType.linear)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(positionFactor: 0.05, widget: _downloadImage)
            ])
      ]),
    );
  }
}
