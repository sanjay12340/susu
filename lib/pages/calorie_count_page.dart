import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/models/calorie_history_detail_modal.dart';
import 'package:susu/pages/step_count_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:intl/intl.dart' show DateFormat;

import '../utils/util.dart';

enum Gender { male, female }

class CalorieCountPage extends StatefulWidget {
  const CalorieCountPage({Key? key}) : super(key: key);

  @override
  _CalorieCountPageState createState() => _CalorieCountPageState();
}

class _CalorieCountPageState extends State<CalorieCountPage> {
  double _size = 150;
  Gender _gender = Gender.male;
  double _value = 0;
  int todayCaloryConsume = 0;
  int todayCaloryConsumeFull = 0;
  int caloryConsumeSize = 10;
  int maxCaloryConsume = 350;
  late Widget _pauseImage;
  late Widget _downloadImage;
  bool completed = false;
  double bmr = 0;
  var box = GetStorage();
  var chartData = <BarModel>[];
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  List<charts.Series<BarModel, String>> createSampleModel() {
    return [
      charts.Series(
        id: "Calorie",
        data: chartData,
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
    _heightController.text = box.read(StorageConstant.height);
    _weightController.text = box.read(StorageConstant.weight);
    _ageController.text = Util.calculateAge(
            DateFormat("yyyy-MM-dd").parse(box.read(StorageConstant.dob)))
        .toStringAsFixed(0);
    setState(() {
      _gender = box.read(StorageConstant.gender) == "male"
          ? Gender.male
          : Gender.female;
      bmr = Util.getBMR(
          age: Util.calculateAge(
              DateFormat("yyyy-MM-dd").parse(box.read(StorageConstant.dob))),
          height: int.parse(box.read(StorageConstant.height)),
          gender: box.read(StorageConstant.gender) == "male"
              ? Gender.male
              : Gender.female,
          weight: int.parse(box.read(StorageConstant.weight)));
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(fontSize: 16, color: Colors.black54);
    const edgeInsets = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Intake Calculator'),
        titleSpacing: 0,
      ),
      backgroundColor: const Color(0xFFf5f5f5),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                Padding(
                  padding: edgeInsets,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "Age",
                          style: textStyle,
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder()),
                      )),
                      gapWidthM2,
                      Text(
                        "ages 15-80",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: edgeInsets,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "Gender",
                          style: textStyle,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                value: Gender.male,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                              ),
                              const Text('Male'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: Gender.female,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                              ),
                              const Text('Female'),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: edgeInsets,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "Height",
                          style: textStyle,
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder()),
                      )),
                      gapWidthM2,
                      Text(
                        "in cm",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: edgeInsets,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "Weight",
                          style: textStyle,
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder()),
                      )),
                      gapWidthM2,
                      Text(
                        "in Kg ",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        bmr = Util.getBMR(
                            age: int.parse(_ageController.text),
                            height: int.parse(_heightController.text),
                            gender: _gender,
                            weight: int.parse(_weightController.text));
                      });
                    },
                    child: const Text("Calculate")),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Result : ${bmr.toStringAsFixed(2)} calories per day required ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        gapHeightM2,
                        Table(
                          border: TableBorder.all(color: Colors.black12),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(5),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                    color: myPrimaryColor.withOpacity(0.1)),
                                children: const [
                                  TableCell(
                                      child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Activity Level",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                                  TableCell(
                                      child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Calorie",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                                ]),
                            tableRow("Sedentary: little or no exercise", 1.2),
                            tableRow("Exercise 1-3 times/week", 1.375),
                            tableRow("Exercise 4-5 times/week", 1.55),
                            tableRow(
                                "Daily exercise or intense exercise 3-4 times/week",
                                1.6),
                            tableRow("Intense exercise 6-7 times/week", 1.725),
                            tableRow(
                                "Very intense exercise daily, or physical job",
                                1.9),
                          ],
                        ),
                      ],
                    ),
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
                          style: TextStyle(color: Colors.black54),
                          children: [
                        TextSpan(
                            text: "Exercise : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "15-30 minutes of elevated heart rate activity.\n"),
                        TextSpan(
                            text: "Intense exercise : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "45-120 minutes of elevated heart rate activity.\n"),
                        TextSpan(
                            text: "Very intense exercise : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "2+ hours of elevated heart rate activity."),
                      ])),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
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
          child: Text((bmr * rowValue).toStringAsFixed(2)),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  GestureDetector sleepIncrement(
      {double? sleepHours, String? inc, IconData? icon}) {
    return GestureDetector(
      onTap: () => {
        print("object"),
        setState(() {
          int f = inc == "inc"
              ? todayCaloryConsume + (caloryConsumeSize)
              : todayCaloryConsume - (caloryConsumeSize);
          if (inc == "inc") {
            // if (maxCaloryConsume <= f) {
            //   print("maxStep $f");
            //   f = maxCaloryConsume;
            // }
          } else {
            if (0 >= f) {
              print("maxStep $f");
              f = 0;
            }
          }
          todayCaloryConsumeFull = todayCaloryConsume = f;
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
        const SizedBox(
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
