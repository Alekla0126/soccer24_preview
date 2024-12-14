
part of 'top_players_bloc.dart';

sealed class TopPlayersEvent extends Equatable {
  final int leagueId;
  final int season;

  const TopPlayersEvent(this.leagueId, this.season);

  @override
  List<Object?> get props => [leagueId, season];
}

class TopScorersEvent extends TopPlayersEvent {
  const TopScorersEvent(super.leagueId, super.season);
}

class TopAssistsEvent extends TopPlayersEvent {
  const TopAssistsEvent(super.leagueId, super.season);
}

class TopYellowCardsEvent extends TopPlayersEvent {
  const TopYellowCardsEvent(super.leagueId, super.season);
}

class TopRedCardsEvent extends TopPlayersEvent {
  const TopRedCardsEvent(super.leagueId, super.season);
}