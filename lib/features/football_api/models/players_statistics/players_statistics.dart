import '../paging.dart';
import 'players_statistic.dart';

class PlayersStatistics {
  final int results;
  final Paging paging;
  final List<PlayersStatistic> playersStatistics;

  PlayersStatistics({
    required this.results,
    required this.paging,
    required this.playersStatistics,
  });

  factory PlayersStatistics.fromJson(Map<String, dynamic> json) => PlayersStatistics(
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        playersStatistics:
            List<PlayersStatistic>.from(json['response'].map((x) => PlayersStatistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(playersStatistics.map((x) => x.toJson())),
      };
}
