import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/models/step_history_detail_modal.dart';
import 'package:susu/pages/step_calorie_bicycle_page.dart';
import 'package:susu/pages/step_calorie_swimming_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:collection/collection.dart';
// import 'package:charts_flutter_new/flutter.dart' as charts;

import 'step_calorie_page.dart';
import 'package:intl/intl.dart';

class StepCountPage extends StatefulWidget {
  const StepCountPage({Key? key}) : super(key: key);

  @override
  _StepCountPageState createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  double _size = 150;
  late Timer _timer;
  TextEditingController _walkingController = TextEditingController();
  TextEditingController _RunningController = TextEditingController();
  var chartData = List<BarModel>.empty(growable: true);

  List<BarModel> createSampleModel() {
    return [
      BarModel(name: "Sample 2", value: 3),
      BarModel(name: "Sample 3", value: 4),
      BarModel(name: "Sample 4", value: 5),
      BarModel(name: "Sample 5", value: 6),
    ];
  }

  var _stepController = TextEditingController();
  int todayStep = 0;
  int todayStepFull = 0;
  int maxStep = 1;
  double _value = 0;
  double _value1 = 20;
  double _value2 = 20;
  double _endValue = 40;
  bool _isLoaded = false;
  Widget _downloadImage = Container(
    height: 40,
    width: 40,
    child: Image.asset("assets/images/footstep.png"),
  );
  var box = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  void saveStep() {
    DashboardService.saveStepTrack(
            step: int.parse(_stepController.text),
            userId: box.read(StorageConstant.id))
        .then((value) {
      _stepController.text = "";
      Get.snackbar(
        "Step",
        "Saved",
        colorText: Colors.white,
        backgroundColor: Colors.black38,
        icon: const Icon(Icons.info),
      );
    });
  }

  void fetchDetail() {
    DashboardService.fetchStepTrack(
            userId: box.read(StorageConstant.id), limit: 8)
        .then((value) {
      if (value != null) {
        Today? today = value.today;
        List<Today>? history = value.history;
        DateTime? lastOrderDate = today?.lastOrderDate;

        setState(() {
          if (today != null) {
            maxStep = int.parse(today.goal ?? "");
            todayStepFull = todayStep = int.parse(today.steps ?? "0");
            double per = (todayStep * 100) / maxStep;
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
            DateTime now = DateTime.now();

            DateFormat dateFormat = DateFormat('yyyy-MM-dd');
            DateFormat dateFinal = DateFormat('dd');

            for (var i = 1; i <= 7; i++) {
              DateTime date = now.subtract(Duration(days: i));
              String formatedDate = dateFormat.format(date);
              Today? t = history.firstWhereOrNull((element) =>
                  formatedDate == dateFormat.format(element.date!));
              print("Steps ${t.toString()}");
              int v = t != null ? int.parse(t.steps ?? "0") : 0;
              print("${dateFinal.format(date)} $v");
              chartData.add(BarModel(name: dateFinal.format(date), value: v));
            }
            chartData = chartData.reversed.toList();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // print("Chart Max:: ${(chartData.sorted((a, b) => (a.value ?? 0) - (b.value ?? 0)).last.value ?? 0) + 1000}");

    return WillPopScope(
      onWillPop: () async {
        // Hide the keyboard
        FocusScope.of(context).unfocus();

        // Wait for a short duration to allow the keyboard to hide
        await Future.delayed(Duration(milliseconds: 100));

        // Perform the back action
        return true; // Set to false to prevent the back action
      },
      child: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Calorie Exercise Calculator'),
          ),
          backgroundColor: Color(0xFFF5F5F5),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(text: "Recommended Goal-", children: [
                                  TextSpan(
                                      text: "${maxStep > 1 ? maxStep : ''}",
                                      style: TextStyle(color: Colors.green))
                                ]),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  _getFourthProgressBar(),
                                ],
                              ),
                              Center(
                                  child: Text("Today's Step $todayStepFull")),
                              if (_value >= 100)
                                Column(
                                  children: [
                                    gapHeightM2,
                                    Row(
                                      children: [
                                        Icon(Icons.thumb_up,
                                            color: Colors.amber.shade600),
                                        gapWidthM2,
                                        const Text("Goal Completed")
                                      ],
                                    )
                                  ],
                                ),
                              gapHeightM2,
                              Row(
                                children: [
                                  SizedBox(
                                      width: 150,
                                      child: TextField(
                                        controller: _stepController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                            isCollapsed: true,
                                            hintText: "Enter steps",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 9),
                                            border: OutlineInputBorder()),
                                      )),
                                  gapWidthM2,
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_stepController.text.isNotEmpty) {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          setState(() {
                                            int f = todayStep +
                                                int.parse(_stepController.text);

                                            if (f <= 0) {
                                              f = 0;
                                            }
                                            todayStepFull = todayStep = f;
                                            double per =
                                                (todayStep * 100) / maxStep;
                                            if (per <= 100) {
                                              _value = per;
                                            } else {
                                              _value = 100;
                                            }
                                            if (per <= 0) {
                                              _value = 0;
                                            }
                                            saveStep();
                                          });
                                        }
                                      },
                                      child: const Text("Save"))
                                ],
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Calorie Burned Calculator - Activity Based",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Walking",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(const StepCaloriePage(
                                name: "Walking",
                                image: "walking.png",
                              ));
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: myPrimaryColor,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Running",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(const StepCaloriePage(
                                name: "Running",
                                image: "running.png",
                              ));
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: myPrimaryColor,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Cycling",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(const StepCaloriePage(
                                name: "Cycling",
                                image: "bicycling.gif",
                              ));
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: myPrimaryColor,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Swimming",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(const StepCalorieSwimmingPage(
                                name: "Swimming",
                                image: 'Swimming.png',
                              ));
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: myPrimaryColor,
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step History",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width - 10,
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              maxY: 10000,
                              barTouchData: BarTouchData(
                                enabled: false,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.transparent,
                                  tooltipPadding: EdgeInsets.zero,
                                  tooltipMargin: 8,
                                  getTooltipItem: (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      rod.toY.round().toString(),
                                      const TextStyle(
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                              barGroups: chartData
                                  .mapIndexed((i, e) => BarChartGroupData(
                                          x: i,
                                          barRods: [
                                            BarChartRodData(
                                                toY: e.value?.toDouble() ?? 0.0)
                                          ],
                                          showingTooltipIndicators: [
                                            0
                                          ]))
                                  .toList(),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      var model = chartData[value.toInt()];
                                      return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(model.name ?? ""));
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                            ),
                          ),
                          // child: SfCartesianChart(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector stepIncrement({int? stepSize}) {
    return GestureDetector(
      onTap: () => {
        print("asd"),
        setState(() {
          int f = todayStep + (stepSize ?? 200);
          if (maxStep <= f) {
            print("maxStep $f");
            f = maxStep;
          }
          if (f <= 0) {
            f = 0;
          }
          todayStep = f;
          double per = (todayStep * 100) / maxStep;
          if (per <= 100) {
            _value = per;
          } else {
            _value = 100;
          }
          if (per <= 0) {
            _value = 0;
          }
        })
      },
      child: Column(children: [
        SizedBox(
            height: 50,
            width: 50,
            child: Image.asset("assets/images/footstep.png")),
        SizedBox(
          height: 10,
        ),
        Text("$stepSize Step")
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
            radiusFactor: 0.8,
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

class BarModel {
  String? name;
  int? value;

  BarModel({required this.name, required this.value});
}
