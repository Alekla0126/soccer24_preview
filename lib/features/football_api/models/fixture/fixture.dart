import 'periods.dart';
import 'status.dart';
import 'venue.dart';

class Fixture {
  final int id;
  final String? referee;
  final String timezone;
  final DateTime date;
  final int timestamp;
  final Periods periods;
  final Venue venue;
  final Status status;

  Fixture({
    required this.id,
    required this.referee,
    required this.timezone,
    required this.date,
    required this.timestamp,
    required this.periods,
    required this.venue,
    required this.status,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) => Fixture(
        id: json['id'],
        referee: json['referee'],
        timezone: json['timezone'],
        date: DateTime.parse(json['date']),
        timestamp: json['timestamp'],
        periods: Periods.fromJson(json['periods']),
        venue: Venue.fromJson(json['venue']),
        status: Status.fromJson(json['status']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'referee': referee,
        'timezone': timezone,
        'date': date.toIso8601String(),
        'timestamp': timestamp,
        'periods': periods.toJson(),
        'venue': venue.toJson(),
        'status': status.toJson(),
      };
}
