import 'team.dart';

class Teams {
  final Team home;
  final Team away;

  Teams({
    required this.home,
    required this.away,
  });

  factory Teams.fromJson(Map<String, dynamic> json) => Teams(
        home: Team.fromJson(json['home']),
        away: Team.fromJson(json['away']),
      );

  Map<String, dynamic> toJson() => {
        'home': home.toJson(),
        'away': away.toJson(),
      };
}