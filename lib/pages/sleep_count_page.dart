import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/pages/step_count_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:intl/intl.dart';

import '../models/sleep_history_detail_modal.dart';

class SleepCountPage extends StatefulWidget {
  const SleepCountPage({Key? key}) : super(key: key);

  @override
  _SleepCountPageState createState() => _SleepCountPageState();
}

class _SleepCountPageState extends State<SleepCountPage> {
  double _size = 150;

  double _value = 0;
  double todaySleep = 0;
  double sleepSize = 0.5;
  double maxSleepHours = 8;
  double maxSleepMinutes = 30;
  String todayTask = "Pending";
  late Widget _pauseImage;
  late Widget _downloadImage;
  bool completed = false;
  String msg = "Recommended";
  String msg2 = "";
  TimeOfDay sleepTime = TimeOfDay(hour: 22, minute: 0);
  TimeOfDay wakeUpTime = TimeOfDay(hour: 6, minute: 0);
  var box = GetStorage();
  var chartData = <BarModel>[];
  List<charts.Series<BarModel, String>> createSampleModel() {
    return [
      charts.Series(
        id: "steps",
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
          image: ExactAssetImage('assets/images/sleep.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
    setTimeDifference();
    fetchDetail();
  }

  void fetchDetail() {
    DashboardService.fetchSleepTrack(
            userId: box.read(StorageConstant.id), limit: 8)
        .then((value) {
      if (value != null) {
        List<Today>? history = value.history;
        setState(() {
          if (history != null) {
            DateTime now = DateTime.now();

            DateFormat dateFormat = DateFormat('yyyy-MM-dd');
            DateFormat dateFinal = DateFormat('dd');
            String today = dateFormat.format(now);

            for (var i = 1; i <= 7; i++) {
              DateTime date = now.subtract(Duration(days: i));

              String formatedDate = dateFormat.format(date);
              Today? t = history.firstWhereOrNull((element) =>
                  formatedDate == dateFormat.format(element.date!));
              Today? t2 = history.firstWhereOrNull((element) =>
                  formatedDate == dateFormat.format(element.createdAt!));

              if (i == 1) {
                print("first date ${formatedDate}");

                if (t != null) {
                  print("first date inside ${t.date}");
                  todayTask = "Done";
                }
              }

              int v = t != null ? int.parse(t.duration ?? "0") : 0;
              chartData.add(BarModel(name: dateFinal.format(date), value: v));
            }
            chartData = chartData.reversed.toList();
          }
        });
      }
    });
  }

  void _incrementPointerValue() {
    setState(() {
      if (_value == 100) {
        _downloadImage = Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: ExactAssetImage('assets/images/check.png'),
              fit: BoxFit.fill,
            )));
        Future<dynamic>.delayed(const Duration(milliseconds: 500));
        completed = true;
      } else {
        _value++;
      }
    });
  }

  void _showTimePicker(TimeOfDay timeOfDay, String mode) {
    showTimePicker(context: context, initialTime: timeOfDay).then((value) {
      if (value != null) {
        if (mode == "wake") {
          wakeUpTime = value;
        } else {
          sleepTime = value;
        }
        setTimeDifference();
      }
    });
  }

  void setTimeDifference() {
    setState(() {
      DateTime now = DateTime.now();
      DateTime sleepDateTime = DateTime(
          now.year, now.month, now.day, sleepTime.hour, sleepTime.minute);
      DateTime wakeUpDateTime = DateTime(
          now.year, now.month, now.day, wakeUpTime.hour, wakeUpTime.minute);

      if (wakeUpTime.hour < sleepTime.hour) {
        // case where wake up time is on the next day
        wakeUpDateTime = wakeUpDateTime.add(Duration(days: 1));
      }

      Duration difference = wakeUpDateTime.difference(sleepDateTime);
      maxSleepHours = difference.inHours.toDouble();
      maxSleepMinutes = difference.inMinutes.remainder(60).toDouble();
      if (maxSleepHours >= 7 && maxSleepHours <= 9) {
        msg = "Recommended";
        msg2 = "";
      } else if (maxSleepHours > 9) {
        msg = "Not Recommended";
        msg2 = "Over Sleep";
      } else if (maxSleepHours < 7) {
        msg = "Not Recommended";
        msg2 = "Less sleep you need it";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: Get.width,
                child: Column(
                  children: [
                    Text(
                      "${maxSleepHours.toInt()}h ${maxSleepMinutes.toInt()}m ",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        TextSpan(children: [
                          TextSpan(text: "Sleep Goal - "),
                          TextSpan(
                              text: msg, style: TextStyle(color: Colors.green)),
                        ])),
                    Text(
                      msg2,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      _showTimePicker(sleepTime, "sleep");
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/night.png",
                          width: 50,
                        ),
                        heightGapSmall,
                        Text(
                          DateFormat('hh:mm a').format(DateTime(
                              2022, 1, 1, sleepTime.hour, sleepTime.minute)),
                          style: TextStyle(fontSize: 22, color: Colors.black54),
                        ),
                      ],
                    )),
                TextButton(
                    onPressed: () {
                      _showTimePicker(wakeUpTime, "wake");
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/day.png",
                          width: 60,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(DateTime(
                              2022, 1, 1, wakeUpTime.hour, wakeUpTime.minute)),
                          style: TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: () {}, child: Text(todayTask)),
              ElevatedButton(
                  onPressed: () {
                    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                    DateTime now = DateTime.now();
                    DateTime sleepDateTime = DateTime(now.year, now.month,
                        now.day, sleepTime.hour, sleepTime.minute);
                    DateTime wakeUpDateTime = DateTime(now.year, now.month,
                        now.day, wakeUpTime.hour, wakeUpTime.minute);
                    print(
                        "Before Wake ${wakeUpTime.hour}  and Sleep ${sleepTime.hour}");
                    if (wakeUpTime.hour < sleepTime.hour) {
                      print(
                          " in fff Before Wake ${wakeUpTime.hour}  and Sleep ${sleepTime.hour}");
                      wakeUpDateTime = wakeUpDateTime.add(Duration(days: 1));
                      print(
                          " in fff Before Wake datetime ${dateFormat.format(wakeUpDateTime)} ");

                      sleepDateTime = sleepDateTime.subtract(Duration(days: 1));
                      wakeUpDateTime =
                          wakeUpDateTime.subtract(Duration(days: 1));
                    }

                    Duration difference =
                        wakeUpDateTime.difference(sleepDateTime);
                    maxSleepHours = difference.inHours.toDouble();
                    maxSleepMinutes =
                        difference.inMinutes.remainder(60).toDouble();

                    DashboardService.saveSleepTrack(
                            startTime: dateFormat.format(sleepDateTime),
                            endTime: dateFormat.format(wakeUpDateTime),
                            durationTime: "${difference.inHours.toInt()}",
                            userId: box.read(StorageConstant.id))
                        .then((value) {
                      setState(() {
                        todayTask = "Done";
                      });
                    });
                  },
                  child: Text("save")),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tips for Better Sleep",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Good sleep habits (sometimes referred to as “sleep hygiene”) can help you get a good night’s sleep.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Some habits that can improve your sleep health:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1."),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                            "Be consistent. Go to bed at the same time each night and get up at the same time each morning, including on the weekends"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("2"),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                            "Make sure your bedroom is quiet, dark, relaxing, and at a comfortable temperature"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("3"),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                            "Remove electronic devices, such as TVs, computers, and smart phones, from the bedroom"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("4"),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                            "Avoid large meals, caffeine, and alcohol before bedtime"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("5"),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                            "Get some exercise. Being physically active during the day can help you fall asleep more easily at night."),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
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
      double f =
          inc == "inc" ? todaySleep + (sleepSize) : todaySleep - (sleepSize);
      if (inc == "inc") {
        if (maxSleepHours <= f) {
          print("maxStep $f");
          f = maxSleepHours;
        }
      } else {
        if (0 >= f) {
          print("maxStep $f");
          f = 0;
        }
      }
      todaySleep = f;
      double per = (todaySleep * 100) / maxSleepHours;
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
              ? todaySleep + (sleepSize)
              : todaySleep - (sleepSize);
          if (inc == "inc") {
            if (maxSleepHours <= f) {
              print("maxStep $f");
              f = maxSleepHours;
            }
          } else {
            if (0 >= f) {
              print("maxStep $f");
              f = 0;
            }
          }
          todaySleep = f;
          double per = (todaySleep * 100) / maxSleepHours;
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
}
