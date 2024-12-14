import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/players_statistics/top_players/top_player_stats.dart';
import '../../repositories/players_repository.dart';
import '../api_state.dart';

part 'top_players_event.dart';
part 'top_players_state.dart';

class TopPlayersBloc extends Bloc<TopPlayersEvent, ApiState> {
  final PlayersRepository _repository;

  TopPlayersBloc(this._repository) : super(const InitialState()) {
    on<TopPlayersEvent>(getTopScorers);
  }

  Future<void> getTopScorers(event, emit) async {
    emit(const LoadingState());
    String pathName;

    switch (event) {
      case TopScorersEvent _:
        pathName = 'topscorers';
        break;
      case TopAssistsEvent _:
        pathName = 'topassists';
        break;
      case TopYellowCardsEvent _:
        pathName = 'topyellowcards';
        break;
      case TopRedCardsEvent _:
        pathName = 'topredcards';
        break;
      default:
        pathName = 'topscorers';
        break;
    }

    try {
      final List<TopPlayersStats> topScorers = await _repository.getTopPlayers(
        pathName: pathName,
        leagueId: event.leagueId,
        season: event.season,
      );
      if (!isClosed) {
        emit(TopPlayersLoadedState(topPlayers: topScorers));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
