import 'prediction_team.dart';

class TeamsStats {
  final TeamStats? home;
  final TeamStats? away;

  TeamsStats({
    required this.home,
    required this.away,
  });

  factory TeamsStats.fromJson(Map<String, dynamic> json) => TeamsStats(
        home: json['home'] == null ? null : TeamStats.fromJson(json['home']),
        away: json['away'] == null ? null : TeamStats.fromJson(json['away']),
      );

  Map<String, dynamic> toJson() => {
        'home': home?.toJson(),
        'away': away?.toJson(),
      };
}