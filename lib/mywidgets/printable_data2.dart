import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/order_detail_full_modal.dart';
import '../utils/bim.dart';
import '../utils/storage_constant.dart';
import '../utils/util.dart';

var box = GetStorage();
var userDetailFont = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);
var gap = pw.SizedBox(height: 10);
var gapW = pw.SizedBox(width: 10);

var healthColor = PdfColors.green;
var unHealthColor = PdfColors.orange;
var toxicColor = PdfColors.red;
var infectedColor = PdfColors.brown;

String getConditionText(int number) {
  if (number > 9) {
    return "Vitality";
  } else if (number >= 6 && number <= 8) {
    return "Unfit";
  } else if (number >= 3 && number <= 5) {
    return "Deviant";
  } else {
    return "Lethal";
  }
}

PdfColor getConditionColor(int number) {
  if (number > 9) {
    return healthColor;
  } else if (number >= 6 && number <= 8) {
    return unHealthColor;
  } else if (number >= 3 && number <= 5) {
    return toxicColor;
  } else {
    return infectedColor;
  }
}

buildPrintableData2(
    {imageFoot, imageSleep, imageCalories, imageWater, imageNutrition}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(25.00),
    child: pw.Column(children: [
      pwCard(imageFoot,
          "Walk up to ${box.read(StorageConstant.gender) == "female" ? 8000 : 10000} Steps"),
      gap,
      pwCard(imageSleep, "Sleep up to min ${Util.sleepByAge()} hours"),
      gap,
      pwCard(imageCalories, "Eat up to ${Util.myBMR().toStringAsFixed(0)} Cal"),
      gap,
      pwCard(imageWater,
          "Drink up to min ${box.read(StorageConstant.gender) == "male" ? 3.5 : 3} Ltr water"),
      gap,
      pwCard(imageNutrition, "Personalized nutrition expertise"),
      gap,
      pw.Column(children: [
        pw.Text(
          "Importance Of Test Parameters - Why Is It Important?",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        gap,
        showHeadDesc(
            head: "Ketones",
            desc:
                "Ketones are chemicals that the body creates when it breaks down fat to use for energy. The body does this when it doesn't have enough glucose. Excessive production of ketones can also be a sign of an underlying health problem. So we will guide you the real time value for your daily physical activity"),
        gap,
        showHeadDesc(
            head: "Bilirubin",
            desc:
                "Bilirubin is a yellowish substance made during your body's normal process of breaking down old red blood cells. It indicates the health of your liver. Higher levels of bilirubin may indicate weak body recovery level and may also indirectly affect the production of melatonin and disrupt the sleep wake cycle."),
        gap,
        showHeadDesc(
            head: "Ph levels",
            desc:
                "Ph level is a measure of the Acidity or alkalinity in our body. A balanced nutrition diet is important to maintain the PH level of our body ie level 7"),
        gap,
        showHeadDesc(
            head: "Specific gravity",
            desc:
                "Specific gravity is use to measure the concentration of substances in urine as well as other bodily fluid which provides information about the function of the kidneys and hydration levels."),
        gap,
        showHeadDesc(
            head: "Glucose",
            desc:
                "Glucose is a simple sugar that is a primary source of energy for the cells in the human body. Maintaining normal glucose levels is important for heath and well being. Eating balance diet, exercising regularly & managing stress levels are some of the ways to help keep glucose levels"),
      ])
    ]),
  );
}

pw.Column showHeadDesc({String? head, String? desc}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        head!,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
      pw.Text(desc!, style: pw.TextStyle(color: PdfColors.grey900)),
    ],
  );
}

pw.Container pwCard(imageFoot, String text) {
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(horizontal: 20),
    decoration:
        pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey200)),
    child: pw.Row(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(10),
          width: 50,
          height: 50,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(30)),
          child: pw.Image(imageFoot, width: 30, height: 30)),
      gapW,
      gapW,
      pw.Flexible(child: pw.Text(text))
    ]),
  );
}
