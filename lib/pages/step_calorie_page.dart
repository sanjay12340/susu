import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/mywidgets/step_card.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:get/get.dart';

import '../utils/storage_constant.dart';
import '../utils/util.dart';

class StepCaloriePage extends StatefulWidget {
  final String? name;
  final String? image;

  const StepCaloriePage({Key? key, this.name, this.image}) : super(key: key);

  @override
  _StepCaloriePageState createState() => _StepCaloriePageState();
}

class _StepCaloriePageState extends State<StepCaloriePage> {
  final _controller = YoutubePlayerController.fromVideoId(
      videoId: "fhyMaNuMVQM", params: YoutubePlayerParams());
  String walkingType = "Slow";
  var speedController = TextEditingController();
  var timeController = TextEditingController();
  var distanceController = TextEditingController();
  var caloryController = TextEditingController();
  var box = GetStorage();
  var items = [
    'Slow',
    'Moderate',
    'Fast',
  ];

  var speed = {"Slow": "3.2", "Moderate": "4.8", "Fast": "5.6"};
  var speedMeet = {"Slow": "2", "Moderate": "3", "Fast": "4.3"};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      if (widget.name == "Running") {
        speed = {"Slow": "11.3", "Moderate": "14.5", "Fast": "19.3"};
        speedMeet = {"Slow": "11", "Moderate": "12.8", "Fast": "19.0"};
      }
      if (widget.name == "Cycling") {
        speed = {"Slow": "17", "Moderate": "23", "Fast": "32.2"};
        speedMeet = {"Slow": "6.8", "Moderate": "10", "Fast": "15.8"};
      }
      speedController.text = speed[walkingType] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name!)),
      backgroundColor: myAppBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StepCard(image: widget.image!),
            heightGapMedium2,
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: myPaddingMedium),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        // Initial Value
                        value: walkingType,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 0))),
                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            walkingType = newValue!;
                            speedController.text = speed[walkingType] ?? '';
                            if (timeController.text.isNotEmpty) {
                              distanceController.text =
                                  ((int.parse(timeController.text) / 60) *
                                          double.parse(speed[walkingType]!))
                                      .toStringAsFixed(2);

                              caloryController.text = Util.caloriesBurn(
                                  int.parse(timeController.text),
                                  double.parse(speedMeet[walkingType]!),
                                  double.parse(
                                      box.read(StorageConstant.weight)));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            heightGapMedium2,
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: myPaddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        readOnly: true,
                        controller: speedController,
                        enabled: false,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'speed'),
                      )),
                      Chip(
                        text: "Km/h",
                      )
                    ],
                  ),
                ),
              ),
            ),
            heightGapMedium2,
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: myPaddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: timeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value != null && value.isNotEmpty) {
                            distanceController.text = ((int.parse(value) / 60) *
                                    double.parse(speed[walkingType]!))
                                .toStringAsFixed(2);
                            ;
                            caloryController.text = Util.caloriesBurn(
                                int.parse(timeController.text),
                                double.parse(speedMeet[walkingType]!),
                                double.parse(box.read(StorageConstant.weight)));
                          }
                        },
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'Time'),
                      )),
                      Chip(
                        text: "Min",
                      )
                    ],
                  ),
                ),
              ),
            ),
            heightGapMedium2,
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: myPaddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        readOnly: true,
                        controller: distanceController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'Distance'),
                      )),
                      Chip(
                        text: "Km",
                      )
                    ],
                  ),
                ),
              ),
            ),
            heightGapMedium2,
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: myPaddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        readOnly: true,
                        controller: caloryController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'Calorie Burn'),
                      )),
                      Chip(
                        text: "Cal",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Chip extends StatelessWidget {
  final String? text;
  const Chip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(text!),
    );
  }
}
