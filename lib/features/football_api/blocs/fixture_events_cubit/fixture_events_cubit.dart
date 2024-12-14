import '../../repositories/fixtures_repository.dart';
import '../../../services/api_service_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/events/fixture_event.dart';
import '../../../../extensions/enums.dart';
import 'fixture_events_state.dart';
import '../api_state.dart';


class FixtureEventsCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  FixtureEventsCubit(this._repository) : super(const InitialState());

  Future getFixtureEvents({
    required int fixtureId,
    int? teamId,
    int? playerId,
    FixtureEventType? type,
  }) async {
    emit(const LoadingState());

    try {
      final List<FixtureEvent> events = await _repository.getFixtureEvents(
        fixtureId: fixtureId,
        teamId: teamId,
        playerId: playerId,
        type: type,
      );
      if (!isClosed) {
        emit(FixtureEventsLoadedState(events: events));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}