import 'player.dart';
import 'player_statistic.dart';

class PlayerStatistics {
  final Player player;
  final List<PlayerStatistic> statistics;

  PlayerStatistics({
    required this.player,
    required this.statistics,
  });

  factory PlayerStatistics.fromJson(Map<String, dynamic> json) => PlayerStatistics(
        player: Player.fromJson(json['player']),
        statistics:
            List<PlayerStatistic>.from(json['statistics'].map((x) => PlayerStatistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'player': player.toJson(),
        'statistics': List<dynamic>.from(statistics.map((x) => x.toJson())),
      };
}
