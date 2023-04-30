import 'package:flutter/material.dart';
import 'package:susu/utils/mycontant.dart';

class BetBoxGame extends StatelessWidget {
  final String text;
  final Color? textColor;
  const BetBoxGame({
    required this.text,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "$text",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor ?? myBlack),
        ),
      ),
    );
  }
}
