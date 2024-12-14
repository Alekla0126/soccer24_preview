import '../../repositories/fixtures_repository.dart';
import '../../models/fixture/fixture_details.dart';
import '../../../services/api_service_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api_state.dart';
import 'dart:async';



part 'fixture_state.dart';

class FixtureCubit extends Cubit<ApiState> {
  final FixturesRepository _repository;

  FixtureCubit(this._repository) : super(const InitialState());

  Future getFixtureById(int id) async {
    emit(const LoadingState());

    try {
      final FixtureDetails fixture = await _repository.getFixtureById(id);
      if (!isClosed) {
        emit(FixtureLoadedState(fixture: fixture));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}