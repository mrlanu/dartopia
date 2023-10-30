class SendUnitsRequest {
  final String to;
  final List<int> units;

  SendUnitsRequest(
      {required this.to,
        required this.units});

  SendUnitsRequest.fromMap(Map<String, dynamic> map)
      : to = map['to'] as String,
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'to': to,
    'units': units,
  };
}
