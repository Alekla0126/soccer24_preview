import 'goals_average.dart';
import 'played_games.dart';
import 'rate_of_total.dart';

class GoalsStatistics {
  final PlayedGames? total;
  final GoalsAverage? average;
  final Map<String, RateOfTotal>? minute;

  GoalsStatistics({
    required this.total,
    required this.average,
    required this.minute,
  });

  factory GoalsStatistics.fromJson(Map<String, dynamic> json) => GoalsStatistics(
        total: json['total'] == null ? null : PlayedGames.fromJson(json['total']),
        average: json['average'] == null ? null : GoalsAverage.fromJson(json['average']),
        minute: json['minute'] == null
            ? null
            : Map.from(json['minute'])
                .map((k, v) => MapEntry<String, RateOfTotal>(k, RateOfTotal.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        'total': total?.toJson(),
        'average': average?.toJson(),
        'minute': Map.from(minute!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
