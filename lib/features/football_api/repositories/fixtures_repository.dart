import '../../../_utils/utils.dart';
import '../../../extensions/enums.dart';
import '../../../extensions/extensions.dart';
import '../../services/api_services.dart';
import '../models/events/fixture_event.dart';
import '../models/events/fixture_events.dart';
import '../models/fixture/fixture_details.dart';
import '../models/fixture/fixtures_model.dart';
import '../models/lineups/fixture_lineup.dart';
import '../models/lineups/fixtures_lineups_model.dart';
import '../models/odds/pre_match_odds_model.dart';
import '../models/players_statistics/players_statistic.dart';
import '../models/players_statistics/players_statistics.dart';
import '../models/predictions/predictions_details.dart';
import '../models/predictions/predictions_model.dart';
import '../models/standings/standings.dart';
import '../models/standings/standings_model.dart';
import '../models/statistics/fixture_statistics.dart';
import '../models/statistics/team_statistic.dart';

class FixturesRepository {
  Future<FixtureDetails> getFixtureById(int id) async {
    try {
      final List<FixtureDetails> fixtures = await getFixtures(id: id);
      return fixtures[0];
    } catch (_) {
      rethrow;
    }
  }

  Future<List<FixtureDetails>> getFixtures({
    int? id,
    List<int>? ids,
    String? live,
    DateTime? date,
    int? leagueId,
    int? season,
    int? teamId,
    int? last,
    int? next,
    String? from,
    String? to,
    String? round,
    String? status,
    int? venueId,
    String? timezone,
  }) async {
    final String endpoint = Utils.buildUrlPath('fixtures', {
      'id': id,
      'ids': ids?.join('-'),
      'live': live,
      'date': date != null ? Utils.formatDateTime(date, 'yyyy-MM-dd') : null,
      'league': leagueId,
      'season': season,
      'team': teamId,
      'last': last,
      'next': next,
      'from': from,
      'to': to,
      'round': round,
      'status': status,
      'venue': venueId,
      'timezone': timezone,
    });

    try {
      final cacheResults = (live == null && !(date?.isSameDay(DateTime.now()) ?? false));

      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: cacheResults ? Utils.hiveBoxName(endpoint) : null,
      );

      final FixturesResponse fixturesResponse = FixturesResponse.fromJson(responseData);

      fixturesResponse.fixtures.sort((a, b) => a.fixture.timestamp.compareTo(b.fixture.timestamp));

      return fixturesResponse.fixtures;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<FixtureEvent>> getFixtureEvents({
    required int fixtureId,
    int? teamId,
    int? playerId,
    FixtureEventType? type,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'fixtures/events',
      {
        'fixture': fixtureId,
        'team': teamId,
        'player': playerId,
        'type': type?.asString,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final FixtureEvents eventsResponse = FixtureEvents.fromJson(responseData);

      return eventsResponse.events;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<FixtureLineup>> getFixtureLineups({
    required int fixtureId,
    int? teamId,
    int? playerId,
    String? type,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'fixtures/lineups',
      {
        'fixture': fixtureId,
        'team': teamId,
        'player': playerId,
        'type': type,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final FixturesLineupsModel lineupsResponse = FixturesLineupsModel.fromJson(responseData);

      return lineupsResponse.lineups;
    } catch (_) {
      rethrow;
    }
  }

  Future<PredictionsDetails?> getFixturePredictions({required int fixtureId}) async {
    final String endpoint = Utils.buildUrlPath(
      'predictions',
      {'fixture': fixtureId},
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final PredictionsModel predictionsResponse = PredictionsModel.fromJson(responseData);

      if (predictionsResponse.predictions.isEmpty) {
        return null;
      }
      return predictionsResponse.predictions[0];
    } catch (_) {
      rethrow;
    }
  }

  Future<List<TeamStatistic>> getFixtureStatistics({
    required int fixtureId,
    int? teamId,
    String? type,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'fixtures/statistics',
      {
        'fixture': fixtureId,
        'team': teamId,
        'type': type,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final FixtureStatistics statisticsResponse = FixtureStatistics.fromJson(responseData);

      return statisticsResponse.teamStatistics;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<FixtureDetails>> getHead2Head({
    required int firstTeamId,
    required int secondTeamId,
    String? date,
    int? league,
    int? season,
    int? last,
    int? next,
    String? from,
    String? to,
    List<FixtureStatusShort>? status,
    int? venue,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'fixtures/headtohead',
      {
        'h2h': '$firstTeamId-$secondTeamId',
        'date': date,
        'league': league,
        'season': season,
        'last': last,
        'next': next,
        'from': from,
        'to': to,
        'status': status?.map((e) => e.asString).toList().join('-'),
        'venue': venue,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final FixturesResponse fixturesData = FixturesResponse.fromJson(responseData);
      final List<FixtureDetails> fixtures = fixturesData.fixtures;

      fixtures.sort((a, b) {
        return b.fixture.timestamp.compareTo(a.fixture.timestamp);
      });
      return fixtures;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<PlayersStatistic>> getPlayersStatistics({
    required int fixtureId,
    int? teamId,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'fixtures/players',
      {
        'fixture': fixtureId,
        'team': teamId,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final PlayersStatistics statisticsResponse = PlayersStatistics.fromJson(responseData);

      return statisticsResponse.playersStatistics;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Standings>> getStandings({
    required int season,
    int? leagueId,
    int? teamId,
  }) async {
    final String endpoint = Utils.buildUrlPath(
      'standings',
      {
        'season': season,
        'league': leagueId,
        'team': teamId,
      },
    );

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final StandingsModel standingsModel = StandingsModel.fromJson(responseData);

      return standingsModel.standings;
    } catch (_) {
      rethrow;
    }
  }

  Future<PreMatchOddsModel> getPreMatchOdds(int fixtureId) async {
    final String endpoint = Utils.buildUrlPath('odds', {'fixture': fixtureId});

    try {
      final responseData = await ApiServices.getApiResponse(
        path: endpoint,
        hiveBoxName: Utils.hiveBoxName(endpoint),
      );

      final PreMatchOddsModel preMatchOddsData = PreMatchOddsModel.fromJson(responseData);

      return preMatchOddsData;
    } catch (_) {
      rethrow;
    }
  }
}
