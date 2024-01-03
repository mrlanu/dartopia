class ReportBrief {
  String id;
  bool read;
  String title;
  DateTime received;

  ReportBrief({
    required this.id,
    required this.read,
    required this.title,
    required this.received,
  });

  ReportBrief.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String,
        read = map['read'] as bool,
        title = map['title'] as String,
        received = DateTime.parse(map['received'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'read': read,
    'title': title,
    'received': received.toIso8601String(),
  };

  ReportBrief copyWith({
    String? id,
    bool? read,
    String? title,
    DateTime? received,
  }) {
    return ReportBrief(
      id: id ?? this.id,
      read: read ?? this.read,
      title: title ?? this.title,
      received: received ?? this.received,
    );
  }
}
