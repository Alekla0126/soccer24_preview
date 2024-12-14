part of 'pinned_leagues_bloc.dart';

sealed class PinnedLeaguesEvent extends Equatable {
  const PinnedLeaguesEvent();
}

class OnPinnedLeaguesChanged extends PinnedLeaguesEvent {
  final List<PinnedLeague> pinnedLeagues;

  const OnPinnedLeaguesChanged(this.pinnedLeagues);

  @override
  List<Object> get props => [pinnedLeagues];
}
