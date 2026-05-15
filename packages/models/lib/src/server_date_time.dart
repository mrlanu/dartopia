/// Java API often returns zone-less ISO-8601 (Jackson [LocalDateTime]) while the
/// Railway host uses UTC. [DateTime.parse] treats those as *local* clock on the
/// device, which skews arrivals, countdowns, and labels. These helpers interpret
/// ambiguous strings as UTC; use normal [DateFormat] / [DateTime.toLocal] in UI.

bool _hasExplicitOffset(String s) =>
    RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(s) || RegExp(r'[+-]\d{4}$').hasMatch(s);

/// Parses a single API date/datetime string as an absolute instant (UTC storage).
DateTime parseServerDateTime(String value) {
  final s = value.trim();
  if (s.isEmpty) {
    throw FormatException('Empty date string', value);
  }
  if (s.endsWith('Z')) {
    return DateTime.parse(s);
  }
  if (_hasExplicitOffset(s)) {
    return DateTime.parse(s);
  }
  if (!s.contains('T')) {
    return DateTime.parse('${s}Z');
  }
  return DateTime.parse('${s}Z');
}

DateTime serverDateTimeFromJson(Object? json) {
  if (json is! String) {
    throw ArgumentError(
      'Expected String for server DateTime, got ${json.runtimeType}',
    );
  }
  return parseServerDateTime(json);
}

DateTime? nullableServerDateTimeFromJson(Object? json) {
  if (json == null) {
    return null;
  }
  if (json is! String) {
    throw ArgumentError(
      'Expected String or null for server DateTime, got ${json.runtimeType}',
    );
  }
  final s = json.trim();
  if (s.isEmpty) {
    return null;
  }
  return parseServerDateTime(s);
}
