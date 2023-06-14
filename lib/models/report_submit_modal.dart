class ReportSubmitData {
  ReportSubmitData({
    required this.orderId,
    required this.variableId,
    required this.name,
    required this.value,
    required this.fname,
    required this.alias,
    required this.start,
    required this.end,
  });
  final String orderId;
  final String variableId;
  final String name;
  final String value;
  final String fname;
  final String alias;
  final String start;
  final String end;

  Map toJson() => {
        'orderId': orderId,
        'variableId': variableId,
        'name': name,
        'value': value,
        'fname': fname,
        'alias': alias,
        'start': start,
        'end': end,
      };
}
