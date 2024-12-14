import '../../paging.dart';
import 'top_player_stats.dart';

class TopPlayers {
  final int results;
  final Paging paging;
  final List<TopPlayersStats> playersStats;

  TopPlayers({
    required this.results,
    required this.paging,
    required this.playersStats,
  });

  factory TopPlayers.fromJson(Map<String, dynamic> json) => TopPlayers(
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        playersStats:
            List<TopPlayersStats>.from(json['response'].map((x) => TopPlayersStats.fromJson(x))),
      );
}
