import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/standings/standings.dart';
import '../../repositories/fixtures_repository.dart';
import '../api_state.dart';
import 'standings_state.dart';

class StandingsCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  StandingsCubit(this._repository) : super(const InitialState());

  Future getStandings({
    required int season,
    int? leagueId,
    int? teamId,
  }) async {
    emit(const LoadingState());

    try {
      final List<Standings> standings = await _repository.getStandings(
        season: season,
        leagueId: leagueId,
        teamId: teamId,
      );
      if (!isClosed) {
        emit(StandingsLoadedState(standings: standings));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
