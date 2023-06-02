import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:im_stepper/stepper.dart';
import 'package:susu/pages/home_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';

class NutritionCountPage extends StatefulWidget {
  const NutritionCountPage({Key? key}) : super(key: key);

  @override
  _NutritionCountPageState createState() => _NutritionCountPageState();
}

class _NutritionCountPageState extends State<NutritionCountPage> {
  int dotCount = 3;
  int activeStep = 0;
  int gestureFirstStep = 1;
  int gestureSecondStep = 1;
  String vegMsg = "";
  var gestureFirstStepArray = ["Weight Loss", "Muscles Gain", "Performance"];
  var gestureSecondStepArray = ["None Vegetarian", "Vegetarian", "Eggitarian"];
  var box = GetStorage();
  List<Map<String, dynamic>> vegActions = [
    {
      "name": "dale",
      "status": false,
    },
    {"name": "wheat", "status": false},
    {"name": "Nuts", "status": false},
    {"name": "Lactose", "status": false},
    {"name": "Soy", "status": false},
    {"name": "Spinach", "status": false},
    {"name": "Broccoli", "status": false},
    {"name": "Kale", "status": false},
    {"name": "Cabbage", "status": false},
    {"name": "Carrots", "status": false},
  ];
  List<Map<String, dynamic>> nonVegActions = [
    {"name": "Chicken", "status": true},
    {"name": "Beef", "status": true},
    {"name": "Pork", "status": true},
    {"name": "Lamb", "status": true},
    {"name": "Fish", "status": true},
    {"name": "Fish", "status": true},
    {"name": "wheat", "status": false},
    {"name": "Nuts", "status": false},
    {"name": "Lactose", "status": false},
    {"name": "Soy", "status": false},
    {"name": "Spinach", "status": false},
    {"name": "Broccoli", "status": false},
    {"name": "Kale", "status": false},
    {"name": "Zucchini", "status": false},
    {"name": "Tomatoes", "status": false},
  ];

  bool none = true;

  List<Map<String, dynamic>> foodAllergiesList() {
    if (gestureSecondStep == 1) {
      return nonVegActions;
    } else if (gestureSecondStep == 2) {
      return vegActions;
    } else {
      return vegActions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: Container(
          height: Get.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DotStepper(
                    // direction: Axis.vertical,
                    dotCount: dotCount,
                    dotRadius: 12,

                    /// THIS MUST BE SET. SEE HOW IT IS CHANGED IN NEXT/PREVIOUS BUTTONS AND JUMP BUTTONS.
                    activeStep: activeStep,
                    shape: Shape.pipe,

                    spacing: 20,

                    indicator: Indicator.shift,

                    /// TAPPING WILL NOT FUNCTION PROPERLY WITHOUT THIS PIECE OF CODE.
                    onDotTapped: (tappedDotIndex) {
                      setState(() {
                        activeStep = tappedDotIndex;
                      });
                    },

                    // DOT-STEPPER DECORATIONS
                    fixedDotDecoration: FixedDotDecoration(
                      color: Colors.grey,
                    ),

                    indicatorDecoration: IndicatorDecoration(
                      // style: PaintingStyle.stroke,
                      strokeWidth: 0,
                      color: myPrimaryColor,
                    ),
                    lineConnectorDecoration: LineConnectorDecoration(
                      color: Colors.grey,
                      strokeWidth: 0,
                    ),
                  ),
                ],
              ),
              activeStep == 0 ? firstStep() : SizedBox.shrink(),
              activeStep == 1 ? secondStep() : SizedBox.shrink(),
              activeStep == 2
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          heightGapLarge,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: const Text(
                                  "What is your Dietary Preference",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          heightGapMedium2,
                          const Text(
                            "Your diet will include foods based on this.",
                            style: TextStyle(color: Colors.black54),
                          ),
                          heightGapMedium2,
                          Row(
                            children: [
                              SizedBox(
                                child: ActionChip(
                                    backgroundColor: myWhite,
                                    onPressed: () {
                                      setState(() {
                                        none = !none;
                                        if (none = true) {
                                          for (var element in vegActions) {
                                            element['status'] = false;
                                            vegMsg = "";
                                          }
                                        }
                                      });
                                    },
                                    avatar: none
                                        ? Icon(
                                            Icons.check_circle,
                                            color: myPrimaryColor,
                                          )
                                        : Icon(Icons.circle_outlined),
                                    label: Text("None")),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 10,
                              children: foodAllergiesList()
                                  .map((e) => ActionChip(
                                      backgroundColor: myWhite,
                                      onPressed: () {
                                        setState(() {
                                          e['status'] = !e['status'];
                                          vegMsg = "";
                                          for (var element in vegActions) {
                                            if (element['status']) {
                                              if (vegMsg.isEmpty) {
                                                vegMsg = element['name'];
                                              } else {
                                                vegMsg +=
                                                    ", ${element['name']}";
                                              }
                                            }
                                            if (vegMsg.isEmpty) {
                                              none = true;
                                            } else {
                                              none = false;
                                            }

                                            print(vegMsg);
                                          }
                                        });
                                      },
                                      avatar: e['status']
                                          ? Icon(
                                              Icons.check_circle,
                                              color: myPrimaryColor,
                                            )
                                          : Icon(Icons.circle_outlined),
                                      label: Text(e['name'])))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ))
                  : SizedBox.shrink(),
              Column(
                children: [
                  activeStep == 2 ? Text(vegMsg) : const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (activeStep > 0) {
                              setState(() {
                                activeStep--;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios, size: 15),
                              Text("Back"),
                            ],
                          )),
                      activeStep < (dotCount - 1)
                          ? TextButton(
                              onPressed: () {
                                if (dotCount > activeStep) {
                                  setState(() {
                                    if (gestureFirstStep == 0 &&
                                        activeStep == 0) {}

                                    activeStep++;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Text("Next"),
                                  Icon(Icons.arrow_forward_ios, size: 15),
                                ],
                              ))
                          : ElevatedButton(
                              onPressed: () {
                                if (dotCount - 1 == activeStep) {
                                  DashboardService.saveNutritionDiet(
                                          bodyType: gestureFirstStepArray[
                                              gestureFirstStep - 1],
                                          diet: gestureSecondStepArray[
                                              gestureSecondStep - 1],
                                          allergy:
                                              vegMsg.isEmpty ? "none" : vegMsg,
                                          userId: box.read(StorageConstant.id))
                                      .then((value) {
                                    if (value != null) {
                                      Map<String, dynamic> map = value;
                                      if (map['status']) {
                                        Get.defaultDialog(
                                            title: "Thank you",
                                            barrierDismissible: false,
                                            confirmTextColor: Colors.black,
                                            onConfirm: () {
                                              if (Get.isDialogOpen!) {
                                                Get.back();
                                              }
                                              Get.offAll(HomePage());
                                            },
                                            content: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Column(
                                                children: const [
                                                  Text(
                                                      "We have your details.\n"),
                                                  Text(
                                                      "Our nutritional experts are on their way to help you achieve your desired transformation, by crafting a dedicated diet plan especially for you.\n\nDon't miss our mail. We'll update you soon.\n\nWith love\nTeam SUSU."),
                                                ],
                                              ),
                                            ));
                                      }
                                    }
                                  });
                                }
                              },
                              child: const Text("Submit"))
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Expanded firstStep() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          heightGapLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Flexible(
                child: Text(
                  "Which diet would suit you?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          heightGapMedium2,
          const Text(
            "Choose your custom diet chart for",
            style: TextStyle(color: Colors.black54),
          ),
          heightGapMedium2,
          GestureDetector(
            onTap: () {
              setState(() {
                gestureFirstStep = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: gestureFirstStep == 1
                      ? Border.all(width: 2, color: myPrimaryColor)
                      : Border.all(width: 2, color: Colors.transparent)),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: myPrimaryColor,
                        child: Icon(
                          Icons.food_bank,
                          color: myWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Weight Loss",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Want to loose some extra inches",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          heightGapSmall,
          GestureDetector(
            onTap: () {
              setState(() {
                gestureFirstStep = 2;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: gestureFirstStep == 2
                      ? Border.all(width: 2, color: myPrimaryColor)
                      : Border.all(width: 2, color: Colors.transparent)),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: myPrimaryColor,
                        child: Icon(
                          Icons.food_bank,
                          color: myWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Muscles Gain",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Want to Gain some extra weight",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          heightGapMedium2,
          GestureDetector(
            onTap: () {
              setState(() {
                gestureFirstStep = 3;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: gestureFirstStep == 3
                      ? Border.all(width: 2, color: myPrimaryColor)
                      : Border.all(width: 2, color: Colors.transparent)),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: myPrimaryColor,
                        child: Icon(
                          Icons.food_bank,
                          color: myWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Performance",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Want to Achieve ultimate fitness level",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Expanded secondStep() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          heightGapLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Flexible(
                child: Text(
                  "What is your Dietary Preference",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          heightGapMedium2,
          const Text(
            "Your diet will include foods based on this.",
            style: TextStyle(color: Colors.black54),
          ),
          heightGapMedium2,
          GestureDetector(
            onTap: () {
              setState(() {
                gestureSecondStep = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: gestureSecondStep == 1
                      ? Border.all(width: 2, color: myPrimaryColor)
                      : Border.all(width: 2, color: Colors.transparent)),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: myPrimaryColor,
                        child: Icon(
                          Icons.food_bank,
                          color: myWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Non Vegetarian",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Chicken,Red Meat,Fish,Prawns etc",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          heightGapSmall,
          GestureDetector(
            onTap: () {
              setState(() {
                gestureSecondStep = 2;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: gestureSecondStep == 2
                      ? Border.all(width: 2, color: myPrimaryColor)
                      : Border.all(width: 2, color: Colors.transparent)),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: myPrimaryColor,
                        child: Icon(Icons.food_bank, color: myWhite),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Vegetarian",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Dale,Rice,Wheat,Gram,Vegetable etc",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          heightGapMedium2,
          GestureDetector(
            onTap: () {
              setState(() {
                gestureSecondStep = 3;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: gestureSecondStep == 3
                      ? Border.all(width: 2, color: myPrimaryColor)
                      : Border.all(width: 2, color: Colors.transparent)),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: myPrimaryColor,
                        child: Icon(
                          Icons.food_bank,
                          color: myWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Eggitarian",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Eggs, Vegetable, etc",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
