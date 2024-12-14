import 'league_stats.dart';
import '../paging.dart';

class TeamStatisticsModel {
  final int resultsCount;
  final Paging paging;
  final LeagueStats teamsStatistics;

  TeamStatisticsModel({
    required this.resultsCount,
    required this.paging,
    required this.teamsStatistics,
  });

  factory TeamStatisticsModel.fromJson(Map<String, dynamic> json) => TeamStatisticsModel(
        resultsCount: json['results'],
        paging: Paging.fromJson(json['paging']),
        teamsStatistics: LeagueStats.fromJson(json['response']),
      );

  Map<String, dynamic> toJson() => {
        'results': resultsCount,
        'paging': paging.toJson(),
        'response': teamsStatistics.toJson(),
      };
}