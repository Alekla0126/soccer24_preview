import 'standings_league.dart';

class Standings {
  final StandingsLeague league;

  Standings({
    required this.league,
  });

  factory Standings.fromJson(Map<String, dynamic> json) => Standings(
        league: StandingsLeague.fromJson(json['league']),
      );

  Map<String, dynamic> toJson() => {
        'league': league.toJson(),
      };
}
