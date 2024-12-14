import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/odds/bookmaker_bets.dart';
import '../../models/odds/pre_match_odds_model.dart';
import '../../repositories/fixtures_repository.dart';
import '../api_state.dart';

part 'odds_state.dart';

class OddsCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  OddsCubit(this._repository) : super(const InitialState());

  Future<void> getPreMatchOddsFromApi(int fixtureId) async {
    emit(const LoadingState());

    try {
      final PreMatchOddsModel preMatchOddsModel =
          await _repository.getPreMatchOdds(fixtureId);
      final List<BookmakerBets> bookmakersBets = preMatchOddsModel.preMatchOdds.isNotEmpty
          ? preMatchOddsModel.preMatchOdds[0].bookmakers
          : [];

      if (!isClosed) {
        emit(OddsLoadedState(bookmakersBets));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
