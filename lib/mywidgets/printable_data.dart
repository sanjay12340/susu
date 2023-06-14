import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/order_detail_full_modal.dart';
import '../utils/bim.dart';
import '../utils/storage_constant.dart';

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

buildPrintableData(
    {String? scheduledPicktimeStart,
    String? age,
    String? bmi,
    OrderDetailFullModal? orderDetailFullModal,
    int? normal,
    imageFoot,
    imageSleep,
    imageCalories,
    imageWater}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(25.00),
    child: pw.Column(children: [
      pw.Text("SUSU Report",
          style: pw.TextStyle(fontSize: 25.00, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10.00),
      pw.Divider(),
      pw.Column(
        children: [
          pw.Container(
            child: pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: pw.Column(children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [pw.Text("Date : ${scheduledPicktimeStart}")],
                ),
                pw.SizedBox(height: 10.00),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Name : ${box.read(StorageConstant.name)}",
                      style: userDetailFont,
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          "Age : ",
                          style: userDetailFont,
                        ),
                        pw.Text("$age Yrs."),
                      ],
                    ),
                  ],
                ),
                gap,
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                          "Gender : ",
                          style: userDetailFont,
                        ),
                        pw.Text(box.read(StorageConstant.gender)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          "Weight :",
                          style: userDetailFont,
                        ),
                        pw.Text("${box.read(StorageConstant.weight)} Kg"),
                      ],
                    ),
                  ],
                ),
                gap,
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                          "Height : ",
                          style: userDetailFont,
                        ),
                        pw.Text("${box.read(StorageConstant.height)} cm"),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      pw.SizedBox(
        width: double.infinity,
        child: pw.Container(
          child: pw.Padding(
            padding: pw.EdgeInsets.all(8.0),
            child: pw.Column(
              children: [
                pw.Text(
                  "BMI Score",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 20),
                ),
                gap,
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    if (bmi != null)
                      pw.Container(
                        alignment: pw.Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: pw.BoxDecoration(
                            color: PdfColors.red,
                            borderRadius: pw.BorderRadius.circular(20)),
                        child: pw.Text(
                          bmi,
                          style: const pw.TextStyle(
                              color: PdfColors.white, fontSize: 22),
                        ),
                      ),
                    gapW,
                    gapW,
                    if (bmi != null)
                      pw.Text(
                        BMI.getBmiExactTextByValue(bmi),
                        style: const pw.TextStyle(fontSize: 16),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      pw.Container(
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    "Results",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              gap,
              pw.Column(children: [
                pw.Row(mainAxisSize: pw.MainAxisSize.max, children: [
                  pw.Expanded(flex: 1, child: pw.Text("Description")),
                  gapW,
                  gapW,
                  gapW,
                  gapW,
                  gapW,
                  gapW,
                  pw.Expanded(flex: 1, child: pw.Text("Range")),
                  gapW,
                  gapW,
                  gapW,
                  pw.Expanded(flex: 1, child: pw.Text("Value")),
                ]),
                pw.Divider(color: PdfColors.grey200),
              ]),
            ],
          ),
        ),
      ),
      ...orderDetailFullModal!.reportDetail!.map(
        (e) => pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text(e.fname!,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 16))),
                gapW,
                gapW,
                gapW,
                gapW,
                gapW,
                gapW,
                pw.Expanded(flex: 1, child: pw.Text(e.alias!)),
                gapW,
                gapW,
                gapW,
                pw.Expanded(flex: 1, child: pw.Text(e.value!)),
              ],
            ),
            pw.Divider(color: PdfColors.grey200)
          ],
        ),
      ),
    ]),
  );
}
