import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:susu/utils/mycontant.dart';

import 'package:get/get.dart';

import '../mywidgets/step_card.dart';

class StepCalorieBicyclePage extends StatefulWidget {
  final String? name;
  final String? image;

  const StepCalorieBicyclePage({Key? key, this.name, this.image})
      : super(key: key);

  @override
  _StepCalorieBicyclePageState createState() => _StepCalorieBicyclePageState();
}

class _StepCalorieBicyclePageState extends State<StepCalorieBicyclePage> {

  String walkingType = "Slow";
  var speedController = TextEditingController(text: "3.5");
  var timeController = TextEditingController();
  var distanceController = TextEditingController();
  var caloryController = TextEditingController();
  var box = GetStorage();
  var speed = {"Slow": "17", "Moderate": "23", "Fast": "32.2"};
  var speedMeet = {"Slow": "6.8", "Moderate": "10", "Fast": "15.8"};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
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
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: timeController,
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
                        controller: caloryController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'Calory Burn'),
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
