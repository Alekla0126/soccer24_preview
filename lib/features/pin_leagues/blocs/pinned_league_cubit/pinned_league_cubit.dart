import '../../repositories/pin_leagues_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pinned_league.dart';


class PinnedLeagueCubit extends Cubit<bool> {
  final PinLeaguesRepository _repository;

  PinnedLeagueCubit(this._repository) : super(false);

  isPinned(int leagueId) {
    emit(_repository.isPinned(leagueId));
  }

  Future switchPinned(PinnedLeague league) async {
    final isPinned = _repository.isPinned(league.id);
    isPinned
        ? await _repository.deletePinnedLeague(league.id)
        : await _repository.savePinnedLeague(league);

    emit(!isPinned);
  }
}