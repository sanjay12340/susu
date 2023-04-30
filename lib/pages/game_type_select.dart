import 'package:susu/pages/harf_ander_bahar_page.dart';
import 'package:susu/pages/harf_bahar_page.dart';
import 'package:susu/pages/jodi_page.dart';

import 'package:flutter/material.dart';
import 'package:susu/models/game_result_model.dart';


class GameTypeSelect extends StatelessWidget {
  final GameResultModel? gameResultModel;
  final String? opneclose;
  const GameTypeSelect({Key? key, this.gameResultModel, this.opneclose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${gameResultModel!.gameName}"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 10, bottom: 20),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GameBox(
                  size: size,
                  gameType: "Jodi",
                  icon: "assets/images/j.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                JodiPage(gameResultModel: gameResultModel!)));
                  },
                ),
            ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GameBox(
                  size: size,
                  gameType: "Harf Ander",
                  icon: "assets/images/jha.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HarafAnderBahar(
                                  gameResultModel: gameResultModel!,
                                  gametype: "ander",
                                  name: "Haraf Ander",
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Harf Bahar",
                  icon: "assets/images/jhb.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HarafAnderBahar(
                                  gameResultModel: gameResultModel,
                                  gametype: "bahar",
                                  name: "Haraf Bahar",
                                )));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GameBox extends StatelessWidget {
  const GameBox({
    Key? key,
    required this.size,
    required this.gameType,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final Size? size;
  final String? gameType;
  final String? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
                image: AssetImage(icon ?? "assets/images/singleank.png"),
                fit: BoxFit.cover)),
      ),
    );
  }
}
