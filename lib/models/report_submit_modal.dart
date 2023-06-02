class ReportSubmitData {
  ReportSubmitData(
      {required this.orderId,
      required this.variableId,
      required this.name,
      required this.value});
  final String orderId;
  final String variableId;
  final String name;
  final String value;

  Map toJson() => {
        'orderId': orderId,
        'variableId': variableId,
        'name': name,
        'value': value,
      };
}
