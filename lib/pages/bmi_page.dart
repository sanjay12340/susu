import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9.,]'),
                    ),
                  ],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "eg 15.45 ",
                      label: Text("Weight in Kg")),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9]'),
                    ),
                  ],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "eg 140 ",
                      label: Text("Height in cm")),
                ),
              )),
            ],
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Calculate")),
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
            name: "Severely Underweight",
            range: "16.0-16.9",
            circleColor: Color(0xFF008bee),
          ),
          const BMIInfo(
            name: "Underweight",
            range: "17.0-18.4",
            circleColor: Color(0xFF25b7fd),
          ),
          const BMIInfo(
            name: "Normal",
            range: "18.5-24.9",
            circleColor: Colors.green,
          ),
          BMIInfo(
            name: "Overweight",
            range: "25.0-29.9",
            circleColor: Colors.amber.shade300,
          ),
          BMIInfo(
            name: "Obese Class 1",
            range: "30.0-34.9",
            circleColor: Colors.amber.shade600,
          ),
          BMIInfo(
            name: "Obese Class 2",
            range: "35.0-39.9",
            circleColor: Colors.amber.shade800,
          ),
          BMIInfo(
            name: "Obese Class 3",
            range: ">=40",
            circleColor: Colors.amber.shade900,
          ),
        ],
      ),
    );
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
            maximum: 45,
            canScaleToFit: true,
            radiusFactor: 0.79,
            pointers: const <GaugePointer>[
              NeedlePointer(
                  needleEndWidth: 5,
                  needleLength: 0.7,
                  value: 24.5,
                  animationDuration: 3000,
                  enableAnimation: true,
                  knobStyle: KnobStyle(knobRadius: 0)),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 15,
                  startWidth: 0.45,
                  endWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.blue),
              GaugeRange(
                  startValue: 15,
                  endValue: 30,
                  startWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.45,
                  color: Colors.green),
              GaugeRange(
                  startValue: 30,
                  endValue: 45,
                  startWidth: 0.45,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.45,
                  color: Colors.red),
            ]),
        RadialAxis(
          showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 360,
          maximum: 45,
          radiusFactor: 0.85,
          canScaleToFit: true,
          pointers: const <GaugePointer>[
            MarkerPointer(
                markerType: MarkerType.text,
                text: 'UnderWeight',
                value: 5.5,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: 'Normal',
                value: 22.5,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Times'),
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.12),
            MarkerPointer(
                markerType: MarkerType.text,
                text: 'OverWeight',
                value: 38.5,
                textStyle: GaugeTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
