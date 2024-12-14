import 'team_statistic.dart';
import '../paging.dart';

class FixtureStatistics {
  final String fixtureStatisticsGet;
  final int results;
  final Paging paging;
  final List<TeamStatistic> teamStatistics;

  FixtureStatistics({
    required this.fixtureStatisticsGet,
    required this.results,
    required this.paging,
    required this.teamStatistics,
  });

  factory FixtureStatistics.fromJson(Map<String, dynamic> json) => FixtureStatistics(
        fixtureStatisticsGet: json['get'],
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        teamStatistics: json['response'] == null
            ? []
            : List<TeamStatistic>.from(json['response'].map((x) => TeamStatistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'get': fixtureStatisticsGet,
        'results': results,
        'paging': paging.toJson(),
        'team_statistics': List<dynamic>.from(teamStatistics.map((x) => x.toJson())),
      };
}