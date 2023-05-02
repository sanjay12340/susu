import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../utils/storage_constant.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? status;
  final _formKey = GlobalKey<FormState>();
  double value = 0;
  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9.,]'),
                        ),
                      ],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "eg 15.45 ",
                          label: Text("Weight in Kg")),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please type Weight";
                        }
                        return null;
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9]'),
                        ),
                      ],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "eg 140 ",
                          label: Text("Height in cm")),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please type Height";
                        }
                        return null;
                      },
                    ),
                  )),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    getBmi(
                        height: int.parse(_heightController.text),
                        weight: int.parse(_weightController.text));
                  }
                },
                child: const Text("Calculate")),
            SizedBox(
              height: 210,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(top: -90, child: _buildRadialTextPointer()),
                  Positioned(
                      bottom: 0,
                      child: Text(
                        status ?? "BMI",
                        style: Get.theme.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
            const BMIInfo(
              name: "Underweight",
              range: "Below -18.4",
              circleColor: Colors.amber,
            ),
            const BMIInfo(
              name: "Normal",
              range: "18.5-24.9",
              circleColor: Colors.green,
            ),
            BMIInfo(
              name: "Overweight",
              range: "25.0-29.9",
              circleColor: Colors.red,
            ),
            BMIInfo(
              name: "Obesity",
              range: "30.0-Above",
              circleColor: Colors.brown,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBmi(
        height: int.parse(StorageConstant.height),
        weight: int.parse(StorageConstant.weight));
  }

  void getBmi({required int height, required int weight}) {
    int h = height;
    int w = weight;
    double v = w / ((h / 100) * (h / 100));
    print("BMI:: $w $h $v");

    if (v < 18.5) {
      value = 22.5;
    } else if (v >= 18.5 && v < 24.9) {
      value = 45;
    } else if (v >= 24.9 && v < 29.9) {
      value = 75;
    } else {
      value = 105;
    }
    setState(() {});
  }

  SfRadialGauge _buildRadialTextPointer() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showAxisLine: false,
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 360,
            maximum: 120,
            canScaleToFit: true,
            radiusFactor: 0.79,
            pointers: <GaugePointer>[
              NeedlePointer(
                  needleEndWidth: 5,
                  needleLength: 0.7,
                  value: value,
                  animationDuration: 3000,
                  enableAnimation: true,
                  knobStyle: KnobStyle(knobRadius: 0)),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 30,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.orange),
              GaugeRange(
                  startValue: 30.5,
                  endValue: 60,
                  startWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.45,
                  color: Colors.green),
              GaugeRange(
                  startValue: 60.5,
                  endValue: 90,
                  sizeUnit: GaugeSizeUnit.factor,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  color: Colors.red),
              GaugeRange(
                  startValue: 90.5,
                  endValue: 120,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.brown),
            ]),
        RadialAxis(
          showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 360,
          maximum: 120,
          radiusFactor: 0.85,
          canScaleToFit: true,
          pointers: const <GaugePointer>[
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 15,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 45,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 75,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: '',
                value: 105,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12)
          ],
        ),
      ],
    );
  }
}

class BMIInfo extends StatelessWidget {
  const BMIInfo({
    super.key,
    required this.name,
    this.fontSize = 16,
    required this.circleColor,
    this.range,
  });
  final String? name;
  final String? range;

  final double? fontSize;
  final Color? circleColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                color: circleColor,
              ),
              Text(name!,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.w600)),
            ],
          ),
          Text(range!,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
