import 'package:flutter/material.dart';
import 'package:susu/mywidgets/printable_data2.dart';
import 'package:susu/mywidgets/printable_data3.dart';
import '../models/order_detail_full_modal.dart';
import 'printable_data.dart';
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SaveBtnBuilder extends StatelessWidget {
  final OrderDetailFullModal? orderDetailFullModal;
  final String? bmi;
  final String? age;
  final String? scheduledPicktimeStart;
  final int? normal;
  const SaveBtnBuilder(
      {Key? key,
      this.orderDetailFullModal,
      this.bmi,
      this.age,
      this.scheduledPicktimeStart,
      this.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.indigo,
        primary: Colors.indigo,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () => printDoc(
          scheduledPicktimeStart: scheduledPicktimeStart,
          age: age,
          bmi: bmi,
          orderDetailFullModal: orderDetailFullModal,
          normal: normal),
      icon: const Icon(Icons.picture_as_pdf),
    );
  }

  Future<void> printDoc(
      {String? scheduledPicktimeStart,
      String? age,
      String? bmi,
      OrderDetailFullModal? orderDetailFullModal,
      int? normal}) async {
    final footImage = await imageFromAssetBundle(
      "assets/images/footstep.png",
    );
    final sleepImage = await imageFromAssetBundle(
      "assets/images/sleep.png",
    );
    final caloriesImage = await imageFromAssetBundle(
      "assets/images/calories.png",
    );
    final waterImage = await imageFromAssetBundle(
      "assets/images/h2o.png",
    );
    final waterNutrition = await imageFromAssetBundle(
      "assets/images/nutrition.png",
    );

    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          orderDetailFullModal!.reportDetail!
              .forEach((e) => {print("Print :: ${e.name}")});
          return buildPrintableData(
            scheduledPicktimeStart: scheduledPicktimeStart,
            age: age,
            bmi: bmi,
            normal: normal,
            orderDetailFullModal: orderDetailFullModal,
            imageCalories: caloriesImage,
            imageSleep: sleepImage,
            imageFoot: footImage,
            imageWater: waterImage,
          );
        }));
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          orderDetailFullModal!.reportDetail!
              .forEach((e) => {print("Print :: ${e.name}")});
          return buildPrintableData2(
              imageCalories: caloriesImage,
              imageSleep: sleepImage,
              imageFoot: footImage,
              imageWater: waterImage,
              imageNutrition: waterNutrition);
        }));
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          orderDetailFullModal!.reportDetail!
              .forEach((e) => {print("Print :: ${e.name}")});
          return buildPrintableData3(
              imageCalories: caloriesImage,
              imageSleep: sleepImage,
              imageFoot: footImage,
              imageWater: waterImage,
              imageNutrition: waterNutrition);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
