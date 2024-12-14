import '../statistics/league_stats.dart';
import 'last5.dart';

class TeamStats {
  final int? id;
  final String? name;
  final Last5? last5Stats;
  final LeagueStats? leagueStats;

  TeamStats({
    required this.id,
    required this.name,
    required this.last5Stats,
    required this.leagueStats,
  });

  factory TeamStats.fromJson(Map<String, dynamic> json) => TeamStats(
        id: json['id'],
        name: json['name'],
        last5Stats: json['last_5'] == null ? null : Last5.fromJson(json['last_5']),
        leagueStats: json['league'] == null ? null : LeagueStats.fromJson(json['league']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'last_5': last5Stats?.toJson(),
        'league': leagueStats?.toJson(),
      };
}
