import 'package:flutter/material.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:get/get.dart';

class StepCalorieSwimmingPage extends StatefulWidget {
  final String? name;

  const StepCalorieSwimmingPage({Key? key, this.name}) : super(key: key);

  @override
  _StepCalorieSwimmingPageState createState() =>
      _StepCalorieSwimmingPageState();
}

class _StepCalorieSwimmingPageState extends State<StepCalorieSwimmingPage> {
  final _controller = YoutubePlayerController.fromVideoId(
      videoId: "fhyMaNuMVQM", params: YoutubePlayerParams());
  String walkingType = "Light";
  var speedController = TextEditingController(text: "3.5");
  var timeController = TextEditingController();
  var distanceController = TextEditingController();
  var caloryController = TextEditingController();

  var items = [
    'Light',
    'Vigours',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name!)),
      backgroundColor: myAppBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
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
                        iconSize: 0,
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
      bottomSheet: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          child: const Text("Save"),
          onPressed: () {},
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
