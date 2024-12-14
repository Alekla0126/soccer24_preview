import 'player_info.dart';
import 'top_player_statistic.dart';

class TopPlayersStats {
  final PlayerInfo player;
  final List<TopPlayerStatistic> statistics;

  TopPlayersStats({
    required this.player,
    required this.statistics,
  });

  factory TopPlayersStats.fromJson(Map<String, dynamic> json) => TopPlayersStats(
        player: PlayerInfo.fromJson(json['player']),
        statistics:
            List<TopPlayerStatistic>.from(json['statistics'].map((x) => TopPlayerStatistic.fromJson(x))),
      );
}
