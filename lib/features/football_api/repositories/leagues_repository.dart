import '../models/leagues/league_model.dart';
import '../../../constants/constants.dart';
import '../../services/api_services.dart';
import '../models/leagues/leagues.dart';
import '../../../_utils/utils.dart';

class LeaguesRepository {
  Future<List<LeagueModel>> getLeagues({
    int? id,
    String? name,
    String? country,
    String? code,
    int? season,
    int? teamId,
    String? type,
    bool? current,
    String? search,
    int? last,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'leagues',
      {
        'id': id,
        'name': name,
        'country': country,
        'code': code,
        'season': season,
        'team': teamId,
        'type': type,
        'current': current,
        'last': last,
      },
    );

    try {
      final responseData =
          await ApiServices.getApiResponse(path: endpoint, hiveBoxName: Constants.leaguesBox);

      final Leagues leaguesResponse = Leagues.fromJson(responseData);

      leaguesResponse.leagues.sort((a, b) => a.league.id.compareTo(b.league.id));

      return leaguesResponse.leagues;
    } catch (_) {
      rethrow;
    }
  }
}