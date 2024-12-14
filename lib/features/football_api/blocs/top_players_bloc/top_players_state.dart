
part of 'top_players_bloc.dart';

class TopPlayersLoadedState extends ApiState {
  final List<TopPlayersStats> topPlayers;

  const TopPlayersLoadedState({required this.topPlayers});

  @override
  List<Object> get props => [];
}