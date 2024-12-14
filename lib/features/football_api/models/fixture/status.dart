import '../../../../extensions/enums.dart';

class Status {
  final FixtureStatusLong long;
  final FixtureStatusShort short;
  final int? elapsed;

  Status({
    required this.long,
    required this.short,
    required this.elapsed,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        long: fixtureStatusLongFromString(json['long']),
        short: fixtureStatusShortFromString(json['short']),
        elapsed: json['elapsed'],
      );

  Map<String, dynamic> toJson() => {
        'long': long.asString,
        'short': short.asString,
        'elapsed': elapsed,
      };
}