import '../../models/statistics/team_statistic.dart';
import '../../repositories/fixtures_repository.dart';
import '../../../services/api_service_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fixture_statistics_state.dart';
import '../api_state.dart';


class FixtureStatisticsCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  FixtureStatisticsCubit(this._repository) : super(const InitialState());

  Future getFixtureStatistics({
    required int fixtureId,
    int? teamId,
    String? type,
  }) async {
    emit(const LoadingState());

    try {
      final List<TeamStatistic> teamStatistics = await _repository.getFixtureStatistics(
        fixtureId: fixtureId,
        teamId: teamId,
        type: type,
      );
      if (!isClosed) {
        emit(FixtureStatisticsLoadedState(teamStatistics: teamStatistics));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}