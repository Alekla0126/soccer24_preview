part of 'pinned_leagues_bloc.dart';

class PinnedLeaguesState extends Equatable {
  final List<PinnedLeague> pinnedLeagues;

  const PinnedLeaguesState(this.pinnedLeagues);

  @override
  List<Object> get props => [pinnedLeagues];
}
