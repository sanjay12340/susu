import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:susu/pages/step_calorie_bicycle_page.dart';
import 'package:susu/pages/step_calorie_swimming_page.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import 'step_calorie_page.dart';

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
  List<charts.Series<BarModel, String>> createSampleModel() {
    final data = [
      BarModel(name: "15", value: 1500),
      BarModel(name: "16", value: 600),
      BarModel(name: "17", value: 1800),
      BarModel(name: "18", value: 100),
      BarModel(name: "19", value: 2500),
      BarModel(name: "20", value: 1200),
      BarModel(name: "21", value: 1300),
      BarModel(name: "22", value: 1400),
      BarModel(name: "23", value: 1500),
    ];
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
  @override
  void initState() {
    super.initState();
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
                                    });
                                  },
                                  icon: Icon(Icons.add_circle_outlined)),
                            ],
                          ),
                          Center(child: Text("Today Step $todayStep")),
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
  BarModel({this.name, this.value});
}
