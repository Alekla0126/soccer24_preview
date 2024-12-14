import '../../repositories/fixtures_repository.dart';
import '../../models/fixture/fixture_details.dart';
import '../../../services/api_service_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api_state.dart';
import 'h2h_state.dart';


class H2HCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  H2HCubit(this._repository) : super(const InitialState());

  Future getHead2Head({
    required int firstTeamId,
    required int secondTeamId,
  }) async {
    emit(const LoadingState());

    try {
      final List<FixtureDetails> fixtures = await _repository.getHead2Head(
        firstTeamId: firstTeamId,
        secondTeamId: secondTeamId,
      );
      if (!isClosed) {
        emit(H2HLoadedState(fixtures: fixtures));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}