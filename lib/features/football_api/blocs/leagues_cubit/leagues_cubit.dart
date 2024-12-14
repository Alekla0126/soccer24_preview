import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/leagues/league_model.dart';
import '../../repositories/leagues_repository.dart';
import '../api_state.dart';
import 'leagues_state.dart';

class LeaguesCubit extends Cubit<ApiState> {
  final LeaguesRepository _repository;

  LeaguesCubit(this._repository) : super(const InitialState());

  Future getLeagues({bool? current}) async {
    emit(const LoadingState());
    try {
      final List<LeagueModel> leagues = await _repository.getLeagues(current: current);
      if (!isClosed) {
        emit(LeaguesLoadedState(leagues: leagues));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
