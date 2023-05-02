import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/models/step_history_detail_modal.dart';
import 'package:susu/pages/step_calorie_bicycle_page.dart';
import 'package:susu/pages/step_calorie_swimming_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

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
  List<charts.Series<BarModel, String>> createSampleModel() {
    var data = chartData;
    return [
      charts.Series(
        id: "steps",
        data: data,
        domainFn: (BarModel barModel, _) => barModel.name!,
        measureFn: (BarModel barModel, _) => barModel.value,
      )
    ];
  }

  int todayStep = 0;
  int todayStepFull = 0;
  int maxStep = 10000;
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
        step: todayStepFull, userId: box.read(StorageConstant.id));
  }

  void fetchDetail() {
    DashboardService.fetchStepTrack(
            userId: box.read(StorageConstant.id), limit: 8)
        .then((value) {
      if (value != null) {
        Today? today = value.today;
        List<Today>? history = value.history;

        setState(() {
          if (today != null) {
            maxStep = int.parse(today.goal ?? "10000");
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

          if (history != null) {
            DateTime now = DateTime.now();

            DateFormat dateFormat = DateFormat('yyyy-MM-dd');
            DateFormat dateFinal = DateFormat('dd');

            for (var i = 1; i <= 7; i++) {
              DateTime date = now.subtract(Duration(days: i));
              String formatedDate = dateFormat.format(date);
              Today? t = history.firstWhereOrNull((element) =>
                  formatedDate == dateFormat.format(element.date!));
              int v = t != null ? int.parse(t.steps ?? "0") : 0;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Count'),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
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
                          Text(
                            "Today Goal $maxStep",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      int f = todayStep - 200;
                                      // if (maxStep <= f) {
                                      //   print("maxStep $f");
                                      //   f = maxStep;
                                      // }
                                      if (f <= 0) {
                                        f = 0;
                                      }
                                      todayStepFull = todayStep = f;
                                      double per = (todayStep * 100) / maxStep;
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
                                  },
                                  icon: Icon(
                                    Icons.remove_circle_outlined,
                                  )),
                              _getFourthProgressBar(),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      int f = todayStep + 200;
                                      // if (maxStep <= f) {
                                      //   print("maxStep $f");
                                      //   f = maxStep;
                                      // }
                                      if (f <= 0) {
                                        f = 0;
                                      }
                                      todayStepFull = todayStep = f;
                                      double per = (todayStep * 100) / maxStep;
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
                                  },
                                  icon: Icon(Icons.add_circle_outlined)),
                            ],
                          ),
                          Center(child: Text("Today Step $todayStepFull")),
                        ]),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Walking",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(StepCaloriePage(name: "Walking"));
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Running",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(StepCaloriePage(name: "Running"));
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Cycling",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(StepCalorieBicyclePage(name: "Cycling"));
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Swimming",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(StepCalorieSwimmingPage(name: "Swimming"));
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        width: Get.width - 10,
                        height: 300,
                        child: charts.BarChart(
                          createSampleModel(),
                          animate: true,
                        )),
                  ],
                ),
              ),
            )
          ],
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
