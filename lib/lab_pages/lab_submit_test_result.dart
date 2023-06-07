import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:susu/lab_pages/lab_home_page.dart';
import 'package:susu/models/report_submit_modal.dart';
import 'package:susu/models/user_order_detail_modal.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:intl/intl.dart';

import '../models/result_variables_modal.dart';

class LabSubmitTestResult extends StatefulWidget {
  final UserOrderDetailModal? userOrderDetailModal;
  final List<ResultVariablesModal> variables;
  LabSubmitTestResult(
      {Key? key, required this.userOrderDetailModal, required this.variables})
      : super(key: key);

  @override
  _LabSubmitTestResultState createState() => _LabSubmitTestResultState();
}

class _LabSubmitTestResultState extends State<LabSubmitTestResult> {
  UserOrderDetailModal? uo;
  List<FormTextField> listController = [];
  late List<ReportSubmitData> report;
  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uo = widget.userOrderDetailModal;
    print("Order Report ${uo!.orderReport}");
  }

  void saveReport() {
    report = [];
    for (var element in listController) {
      report.add(ReportSubmitData(
          orderId: uo!.orderDetail!.id!,
          variableId: "",
          name: element.name!,
          value: element.controller.text));
    }
    DashboardService.saveReportDeatil(
            report: report, orderId: uo!.orderDetail!.id!)
        .then((value) {
      print("Value Print :::: $value");
      if (value != null) {
        if (value['status']) {
          Get.offAll(LabHomePage());
        }
      }
    });
  }

  int calculateAge({required DateTime fromDate}) {
    DateTime currentDate = fromDate;
    DateTime birthDate = uo!.user!.dob!;
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    print("Age $age");
    return age;
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    listController = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Test Result"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: myBlack, fontSize: 14),
                                children: [
                              TextSpan(
                                  text: "Order No : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: uo!.orderDetail!.orderNo)
                            ])),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: myBlack, fontSize: 14),
                                children: [
                              TextSpan(
                                  text: "Date : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "${DateFormat("dd/MM/yyyy").format(uo!.orderDetail!.scheduledPicktimeStart!)}")
                            ])),
                      ],
                    ),
                    Row(
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: myBlack, fontSize: 14),
                                children: [
                              TextSpan(
                                  text: "username : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: uo!.user!.name!)
                            ])),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: myBlack),
                                children: [
                              TextSpan(
                                  text: "Dob : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "${DateFormat("dd/MM/yyyy").format(uo!.user!.dob!)} (${calculateAge(fromDate: uo!.orderDetail!.scheduledPicktimeStart!)} Years)")
                            ])),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: myBlack),
                                children: [
                              TextSpan(
                                  text: "Gender : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: uo!.user!.sex!)
                            ]))
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Text(
              "Result",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: Get.width * 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                width: Get.width * 0.1, child: Text("Sr.")),
                            SizedBox(
                              width: Get.width * 0.4,
                              child: Center(child: Text("Result")),
                            ),
                            SizedBox(
                                width: Get.width * 0.3, child: Text("Values")),
                          ],
                        ),
                      ),
                      gapHeightL1,
                      uo!.orderReport != null && uo!.orderReport!.isNotEmpty
                          ? Wrap(
                              runSpacing: 15,
                              spacing: 15,
                              children: uo!.orderReport!.map((e) {
                                index++;
                                var f = FormTextField(
                                  name: e.name,
                                  index: index,
                                  dimension: e.alise!,
                                  fanme: e.fname,
                                );
                                f.controller.text = e.value!;
                                listController.add(f);
                                return f;
                              }).toList(),
                            )
                          : Wrap(
                              runSpacing: 15,
                              spacing: 15,
                              children: widget.variables.map((e) {
                                index++;
                                var f = FormTextField(
                                  name: e.name,
                                  index: index,
                                  dimension: e.alise!,
                                  fanme: e.fname,
                                );

                                listController.add(f);
                                return f;
                              }).toList(),
                            ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveReport();
                            }
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  FormTextField({
    super.key,
    this.name,
    required this.index,
    required this.dimension,
    this.fanme,
  });
  final String? name;
  final String? fanme;
  final int index;
  final String dimension;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: Get.width * 0.1, child: Text("$index")),
          SizedBox(
            width: Get.width * 0.4,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  hintText: fanme ?? name,
                  labelText: name,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Value cant Empty";
                }
                return null;
              },
            ),
          ),
          SizedBox(width: Get.width * 0.3, child: Text(dimension)),
        ],
      ),
    );
  }
}
