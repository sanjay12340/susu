import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:susu/utils/mycontant.dart';

class RangeMeter extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int value;

  const RangeMeter({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = value.toDouble() / maxValue.toDouble();

    print("ValueToday:::: $value Max $maxValue");

    return Container(
      width: 25.0,
      height: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 300 *  percentage,
            decoration: BoxDecoration(
              color: myPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
