import '../../models/leagues/league_model.dart';
import '../api_state.dart';

class LeaguesLoadedState extends ApiState {
  final List<LeagueModel> leagues;

  const LeaguesLoadedState({required this.leagues});

  @override
  List<Object> get props => [leagues];
}
