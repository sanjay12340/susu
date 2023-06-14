
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class PdfPreviewPage extends StatelessWidget {
  String? text;
   PdfPreviewPage(this.text, {Key? key}) : super(key: key);
   
      @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

   Future<Uint8List> makePdf() async {
    final pdf = pw.Document();

 
    pdf.addPage(
        pw.Page(
            margin: const pw.EdgeInsets.all(10),
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Header(text: "About Cat", level: 1),
                     
                      ]
                    ),
                    pw.Divider(borderStyle: pw.BorderStyle.dashed),
                    pw.Paragraph(text: text),
                  ]
              );
            }
        ));
    return pdf.save();
  }
  }