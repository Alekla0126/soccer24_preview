import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions/extensions.dart';
import '../../../services/api_service_error.dart';
import '../../models/fixture/fixture_details.dart';
import '../../repositories/fixtures_repository.dart';
import '../api_state.dart';

part 'fixtures_state.dart';

class FixturesCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  FixturesCubit(this._repository) : super(const InitialState());

  Future getFixtures({
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
    emit(const LoadingState());

    try {
      final List<FixtureDetails> fixtures = await _repository.getFixtures(
        id: id,
        ids: ids,
        live: live,
        date: date,
        leagueId: leagueId,
        season: season,
        teamId: teamId,
        last: last,
        next: next,
        from: from,
        to: to,
        round: round,
        status: status,
        venueId: venueId,
        timezone: timezone,
      );

      int? firstUpcomingIndex;
      for (int i = 0; i < fixtures.length; i++) {
        if (fixtures[i].fixture.date.isAfter(DateTime.now().toMidnight())) {
          firstUpcomingIndex = i;
          break;
        }
      }

      firstUpcomingIndex ??= fixtures.length - 1;

      if (!isClosed) {
        emit(FixturesLoadedState(fixtures: fixtures, firstUpcomingIndex: firstUpcomingIndex));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
