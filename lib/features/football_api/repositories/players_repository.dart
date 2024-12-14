import '../models/players_statistics/top_players/top_player_stats.dart';
import '../models/players_statistics/top_players/top_players.dart';
import '../../services/api_services.dart';
import '../../../_utils/utils.dart';

class PlayersRepository {
  Future<List<TopPlayersStats>> getTopPlayers({
    required pathName,
    required int leagueId,
    required int season,
  }) async {
    final endpoint = Utils.buildUrlPath(
      'players/$pathName',
      {
        'league': leagueId,
        'season': season,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final TopPlayers top = TopPlayers.fromJson(responseData);

      return top.playersStats;
    } catch (_) {
      rethrow;
    }
  }
}