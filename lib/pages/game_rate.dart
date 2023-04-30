import 'package:susu/models/game_rate_model.dart';

import 'package:susu/services/genral_api_call.dart';
import 'package:flutter/material.dart';

class GameRatePage extends StatefulWidget {
  GameRatePage({Key? key}) : super(key: key);

  @override
  _GameRatePageState createState() => _GameRatePageState();
}

class _GameRatePageState extends State<GameRatePage> {
  GenralApiCallService? genralApiCallService;
  @override
  void initState() {
    super.initState();
    genralApiCallService = GenralApiCallService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Rate"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: genralApiCallService!.fetchGenralQueryWithRawData(
            "SELECT   `type_name2` as fname, `price` FROM `starline_game_type` order by id"),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Text("No Internet Connection"),
                  ),
                ],
              );

            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );

            default:
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  List<GameRateModel> l =
                      gameRateModelFromJson(snapshot.data.toString());
                  return Column(
                    children: [
                      Table(
                          columnWidths: {
                            0: FlexColumnWidth(1.5),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(children: [
                              TableCellResultHead(text: "Game Name"),
                              TableCellResultHead(text: "Rate"),
                              TableCellResultHead(text: "Rate X 10"),
                            ])
                          ]),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(1.5),
                          },
                          border: TableBorder.all(),
                          children: List.generate(l.length, (index) {
                            return TableRow(children: [
                              TableCellResult(text: l[index].fname!),
                              TableCellResult(text: l[index].price!),
                              TableCellResult(
                                  text:
                                      "${double.parse(l[index].price!) * 10}"),
                            ]);
                          }),
                        ),
                      ))
                    ],
                  );
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class TableCellResult extends StatelessWidget {
  const TableCellResult({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$text",
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class TableCellResultHead extends StatelessWidget {
  const TableCellResultHead({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      color: Colors.red.shade900,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$text",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
