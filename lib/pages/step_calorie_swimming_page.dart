import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:get/get.dart';

import '../mywidgets/step_card.dart';
import '../utils/storage_constant.dart';
import '../utils/util.dart';

class StepCalorieSwimmingPage extends StatefulWidget {
  final String? name;
  final String? image;

  const StepCalorieSwimmingPage({Key? key, this.name, this.image})
      : super(key: key);

  @override
  _StepCalorieSwimmingPageState createState() =>
      _StepCalorieSwimmingPageState();
}

class _StepCalorieSwimmingPageState extends State<StepCalorieSwimmingPage> {

  String walkingType = "Backstroke";
  var speedController = TextEditingController(text: "3.5");
  var timeController = TextEditingController();
  var distanceController = TextEditingController();
  var caloryController = TextEditingController();
  var box = GetStorage();
  var items = [
    'Backstroke',
    'Breaststoke',
    'Butterfly',
    'Sidestroke',
    'Treading water',
    'Water Walking',
  ];

  var speed = {"Slow": "3.2", "Moderate": "4.8", "Fast": "5.6"};
  var speedMeet = {
    "Backstroke": "9.5",
    "Breaststoke": "10.3",
    "Butterfly": "13.8",
    "Sidestroke": "7",
    "Treading water": "3.5",
    "Water Walking": "4.5"
  };

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
                            caloryController.text = Util.caloriesBurn(
                                int.parse(timeController.text),
                                double.parse(speedMeet[walkingType]!),
                                double.parse(box.read(StorageConstant.weight)));
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
                        controller: timeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value != null && value.isNotEmpty) {
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
