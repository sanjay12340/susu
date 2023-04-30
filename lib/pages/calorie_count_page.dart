import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:susu/pages/step_count_page.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class CalorieCountPage extends StatefulWidget {
  const CalorieCountPage({Key? key}) : super(key: key);

  @override
  _CalorieCountPageState createState() => _CalorieCountPageState();
}

class _CalorieCountPageState extends State<CalorieCountPage> {
  double _size = 150;

  double _value = 0;
  double todayCaloryConsume = 0;
  double caloryConsumeSize = 10;
  double maxCaloryConsume = 350;
  late Widget _pauseImage;
  late Widget _downloadImage;
  bool completed = false;

  List<charts.Series<BarModel, String>> createSampleModel() {
    final data = [
      BarModel(name: "15", value: 8),
      BarModel(name: "16", value: 7),
      BarModel(name: "17", value: 6),
      BarModel(name: "18", value: 7),
      BarModel(name: "19", value: 5),
      BarModel(name: "20", value: 8),
      BarModel(name: "21", value: 12),
      BarModel(name: "22", value: 6),
      BarModel(name: "23", value: 8),
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

  @override
  void initState() {
    super.initState();
    _pauseImage = Container(
      height: 60,
      width: 60,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/calories.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void _incrementPointerValue() {
    setState(() {
      if (_value == 100) {
        _downloadImage = Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: ExactAssetImage('assets/images/calories.png'),
              fit: BoxFit.fill,
            )));
        Future<dynamic>.delayed(const Duration(milliseconds: 500));
        completed = true;
      } else {
        _value++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories'),
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Goal $maxCaloryConsume Calories",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            setCount(inc: "dec");
                          },
                          icon: Icon(Icons.remove_circle)),
                      _getThirdProgressBar(),
                      IconButton(
                          onPressed: () {
                            setCount(inc: "inc");
                          },
                          icon: Icon(Icons.add_circle)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Today Step $todayCaloryConsume"),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Image.asset("assets/images/diet.png")],
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
                    "Calorie Consume History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCount({String? inc}) {
    setState(() {
      double f = inc == "inc"
          ? todayCaloryConsume + (caloryConsumeSize)
          : todayCaloryConsume - (caloryConsumeSize);
      if (inc == "inc") {
        if (maxCaloryConsume <= f) {
          print("maxStep $f");
          f = maxCaloryConsume;
        }
      } else {
        if (0 >= f) {
          print("maxStep $f");
          f = 0;
        }
      }
      todayCaloryConsume = f;
      double per = (todayCaloryConsume * 100) / maxCaloryConsume;
      if (per < 100) {
        _value = per;
      } else {
        _value = 100;
      }
    });
  }

  GestureDetector sleepIncrement(
      {double? sleepHours, String? inc, IconData? icon}) {
    return GestureDetector(
      onTap: () => {
        print("object"),
        setState(() {
          double f = inc == "inc"
              ? todayCaloryConsume + (caloryConsumeSize)
              : todayCaloryConsume - (caloryConsumeSize);
          if (inc == "inc") {
            if (maxCaloryConsume <= f) {
              print("maxStep $f");
              f = maxCaloryConsume;
            }
          } else {
            if (0 >= f) {
              print("maxStep $f");
              f = 0;
            }
          }
          todayCaloryConsume = f;
          double per = (todayCaloryConsume * 100) / maxCaloryConsume;
          if (per < 100) {
            _value = per;
          } else {
            _value = 100;
          }
        })
      },
      child: Column(children: [
        Icon(
          icon,
          color: myPrimaryColor,
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Widget _getThirdProgressBar() {
    return Center(
      child: SizedBox(
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
                thickness: 0.05,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                    value: _value,
                    width: 0.05,
                    sizeUnit: GaugeSizeUnit.factor,
                    enableAnimation: true,
                    animationDuration: 20,
                    animationType: AnimationType.linear)
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.05,
                    widget: completed ? _downloadImage : _pauseImage)
              ])
        ]),
      ),
    );
  }
}
