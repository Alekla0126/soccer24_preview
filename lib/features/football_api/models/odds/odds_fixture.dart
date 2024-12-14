class OddsFixture {
  final int id;
  final String timezone;
  final DateTime date;
  final int timestamp;

  OddsFixture({
    required this.id,
    required this.timezone,
    required this.date,
    required this.timestamp,
  });

  factory OddsFixture.fromJson(Map<String, dynamic> json) => OddsFixture(
        id: json['id'],
        timezone: json['timezone'],
        date: DateTime.parse(json['date']),
        timestamp: json['timestamp'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'timezone': timezone,
        'date': date.toIso8601String(),
        'timestamp': timestamp,
      };
}
