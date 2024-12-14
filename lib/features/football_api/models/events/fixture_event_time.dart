
class FixtureEventTime {
  final int? elapsed;
  final int? extra;

  FixtureEventTime({
    required this.elapsed,
    required this.extra,
  });

  factory FixtureEventTime.fromJson(Map<String, dynamic> json) => FixtureEventTime(
        elapsed: json['elapsed'],
        extra: json['extra'],
      );

  Map<String, dynamic> toJson() => {
        'elapsed': elapsed,
        'extra': extra,
      };
}