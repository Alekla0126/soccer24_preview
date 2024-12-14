import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/lineups/fixture_lineup.dart';
import '../../models/players_statistics/players_statistic.dart';
import '../../repositories/fixtures_repository.dart';
import '../api_state.dart';
import 'fixture_lineups_state.dart';

class FixtureLineupsCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  FixtureLineupsCubit(this._repository) : super(const InitialState());

  Future getFixtureLineups({
    required int fixtureId,
    int? teamId,
    int? playerId,
    String? type,
    required bool getPlayersStats,
  }) async {
    emit(const LoadingState());

    try {
      final List<FixtureLineup> lineups = await _repository.getFixtureLineups(
        fixtureId: fixtureId,
        teamId: teamId,
        playerId: playerId,
        type: type,
      );

      List<PlayersStatistic> playersStatistics = [];
      //get players statistics only when fixture started
      if (getPlayersStats) {
        playersStatistics = await _repository.getPlayersStatistics(
          fixtureId: fixtureId,
        );
      }
      if (!isClosed) {
        emit(
          FixtureLineupsLoadedState(
            lineups: lineups,
            playersStatistics: playersStatistics,
          ),
        );
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
