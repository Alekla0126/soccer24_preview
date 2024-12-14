import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/predictions/predictions_details.dart';
import '../../repositories/fixtures_repository.dart';
import '../api_state.dart';
import 'fixture_predictions_state.dart';

class FixturePredictionsCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  FixturePredictionsCubit(this._repository) : super(const InitialState());

  Future getFixturePredictions({
    required int fixtureId,
  }) async {
    emit(const LoadingState());

    try {
      final PredictionsDetails? predictions =
          await _repository.getFixturePredictions(fixtureId: fixtureId);
      if (!isClosed) {
        emit(FixturePredictionsLoadedState(predictions: predictions));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
