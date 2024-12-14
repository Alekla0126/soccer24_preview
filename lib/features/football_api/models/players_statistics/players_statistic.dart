import '../lineups/fixture_team.dart';
import 'player_statistics.dart';

class PlayersStatistic {
  final FixtureTeam team;
  final List<PlayerStatistics> players;

  PlayersStatistic({
    required this.team,
    required this.players,
  });

  factory PlayersStatistic.fromJson(Map<String, dynamic> json) => PlayersStatistic(
        team: FixtureTeam.fromJson(json['team']),
        players:
            List<PlayerStatistics>.from(json['players'].map((x) => PlayerStatistics.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'team': team.toJson(),
        'players': List<dynamic>.from(players.map((x) => x.toJson())),
      };
}