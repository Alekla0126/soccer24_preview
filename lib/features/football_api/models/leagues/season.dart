import 'coverage.dart';

class Season {
  final int year;
  final DateTime start;
  final DateTime end;
  final bool current;
  final Coverage coverage;

  Season({
    required this.year,
    required this.start,
    required this.end,
    required this.current,
    required this.coverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        year: json['year'],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        current: json['current'],
        coverage: Coverage.fromJson(json['coverage']),
      );

  Map<String, dynamic> toJson() => {
        'year': year,
        'start':
            "${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}",
        'end':
            "${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}",
        'current': current,
        'coverage': coverage.toJson(),
      };
}
