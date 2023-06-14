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

buildPrintableData3(
    {imageFoot, imageSleep, imageCalories, imageWater, imageNutrition}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(25.00),
    child: pw.Column(children: [
      gap,
      showHeadDesc(
          head: "Urobilinogen (URO)",
          desc:
              """Our body produces urobilinogen when old red blood cells decompose, and bilirubin is one of the 
byproducts. When you have a high or low level of urobilinogen in your urine, that may indicate one or 
more liver conditions. 
Susu can guide you on keeping your liver healthy."""),
      gap,
      showHeadDesc(
          head: "Proteinuria (Pro)",
          desc:
              """Having an excess of proteins in your urine is known as proteinuria (pro-TEE-NU-ree-uh). The 
presence of low levels of protein in urine is typical, while the presence of high levels is 
indicative of kidney disease.
Through SUSU, you will be able to generate a good amount of metabolic energy, which will be 
beneficial to protein intake and muscle growth."""),
      gap,
      showHeadDesc(
          head: "Nitrogen (NIT)",
          desc:
              """An indicator of urine urea nitrogen is the presence of urea in the urine. During protein
breakdown, urea is produced as a waste product as an indicator of kidney efficiency and a 
measurement of how much protein your body consumes.
Your body will benefit from SUSU's nutritional guidance, so that you have an optimal amount of 
calories, proteins, and fats."""),
      gap,
      showHeadDesc(
          head: "Leukocyte (LEU)",
          desc:
              """White blood cells, also known as leukocytes, are responsible for fighting germs in the body.
There is a possibility that an infection is manifested by the presence of higher levels of 
leukocytes in the urine.
Through Susu, you will improve your daily living activity, which improves your immune system."""),
      gap,
      showHeadDesc(
          head: "Vitamin C (VC)",
          desc:
              """ Vitamin C is an antioxidant that aids in many bodily functions, such as digestion. In excessive 
amounts (more than 2,000 mg), it can cause diarrhoea and nausea.
SUSU provides nutrition advice that will help you maintain the right balance of vitamins and 
minerals in your body."""),
      gap,
      showHeadDesc(
          head: "Blood (BLD)",
          desc:
              """A urinalysis is a test that determines whether you have blood in your urine, which indicates your 
general health as well as the health of your urinary tract, kidneys, and liver."""),
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
      pw.Flexible(child: pw.Text(text))
    ]),
  );
}
