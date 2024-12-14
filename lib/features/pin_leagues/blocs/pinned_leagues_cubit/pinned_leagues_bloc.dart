import '../../repositories/pin_leagues_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';
import '../../models/pinned_league.dart';
import 'dart:async';



part 'pinned_leagues_event.dart';
part 'pinned_leagues_state.dart';

class PinnedLeaguesBloc extends Bloc<PinnedLeaguesEvent, PinnedLeaguesState> {
  final PinLeaguesRepository _repository;
  StreamSubscription<BoxEvent>? _streamSubscription;

  PinnedLeaguesBloc(this._repository)
      : super(PinnedLeaguesState(_repository.getPinnedLeagues())) {
    _streamSubscription = _repository.pinnedLeaguesStream.listen((event) {
      add(OnPinnedLeaguesChanged(_repository.getPinnedLeagues()));
    });

    on<OnPinnedLeaguesChanged>(_onPinnedLeaguesChanged);
  }

  _onPinnedLeaguesChanged(
    OnPinnedLeaguesChanged event,
    Emitter<PinnedLeaguesState> emit,
  ) {
    emit(PinnedLeaguesState(event.pinnedLeagues));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}