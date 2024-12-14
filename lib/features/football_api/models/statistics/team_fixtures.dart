import 'played_games.dart';

class TeamFixtures {
  final PlayedGames? played;
  final PlayedGames? wins;
  final PlayedGames? draws;
  final PlayedGames? loses;

  TeamFixtures({
    required this.played,
    required this.wins,
    required this.draws,
    required this.loses,
  });

  factory TeamFixtures.fromJson(Map<String, dynamic> json) => TeamFixtures(
        played: json['played'] == null ? null : PlayedGames.fromJson(json['played']),
        wins: json['wins'] == null ? null : PlayedGames.fromJson(json['wins']),
        draws: json['draws'] == null ? null : PlayedGames.fromJson(json['draws']),
        loses: json['loses'] == null ? null : PlayedGames.fromJson(json['loses']),
      );

  Map<String, dynamic> toJson() => {
        'played': played?.toJson(),
        'wins': wins?.toJson(),
        'draws': draws?.toJson(),
        'loses': loses?.toJson(),
      };
}