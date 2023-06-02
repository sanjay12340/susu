import 'package:flutter/material.dart';

class StepCard extends StatelessWidget {
  const StepCard({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Image.asset("assets/images/$image"),
    );
  }
}
