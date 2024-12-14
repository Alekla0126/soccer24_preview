import '../fixture/team.dart';
import 'statistic.dart';

class TeamStatistic {
  final Team team;
  final List<Statistic> statistics;

  TeamStatistic({
    required this.team,
    required this.statistics,
  });

  factory TeamStatistic.fromJson(Map<String, dynamic> json) => TeamStatistic(
        team: Team.fromJson(json['team']),
        statistics: List<Statistic>.from(json['statistics'].map((x) => Statistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'team': team.toJson(),
        'statistics': List<dynamic>.from(statistics.map((x) => x.toJson())),
      };
}
