import 'package:susu/models/get_invite_detail_model.dart';
import 'package:susu/services/game_result_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitePage extends StatefulWidget {
  InvitePage({Key? key}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  var todayContribution = "0.00".obs;
  var totalContribution = "0.00".obs;
  var todayActiveUSer = "0".obs;
  var totalUser = "0".obs;
  var bonus = "0.00".obs;
  GetInviteDetail getInviteDetail = GetInviteDetail();
  var box = GetStorage();
  @override
  void initState() {
    super.initState();

    getInvideDetails();
  }

  getInvideDetails() {
    RemoteGameResultService.getInviteDetail().then((value) {
      bonus.value = value.bonus ?? "0";
      todayContribution.value = value.todayContribution ?? "0";
      totalContribution.value = value.totalContribution ?? "0";
      totalUser.value = value.totalUser ?? "0";
      todayActiveUSer.value = value.todayActiveUSer ?? "0";
    });
  }

  void _launchURL() async => await canLaunch(
          "https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}")
      ? await launch(
          "https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}")
      : throw "Could not launch https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share & Earn"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Obx(
            () => Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: myPrimaryColor),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Bonus\n ${bonus.value}",
                          style: TextStyle(color: myWhite, fontSize: 18),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        width: Get.size.longestSide,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(30)),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: TextButton(
                            onPressed: () {
                              _launchURL();
                              // print(box.read('share'));
                            },
                            child: Text(
                              "Share & Earn",
                              style: TextStyle(color: myBlack, fontSize: 18),
                            )),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: myPrimaryColor),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Today Active User\n ${todayActiveUSer.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Today Contribution\n${todayContribution.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: myPrimaryColor),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Total User\n ${totalUser.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Total Contribution\n${totalContribution.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
