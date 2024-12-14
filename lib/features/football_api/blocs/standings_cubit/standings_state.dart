import '../../models/standings/standings.dart';
import '../api_state.dart';

class StandingsLoadedState extends ApiState {
  final List<Standings> standings;

  const StandingsLoadedState({required this.standings});

  @override
  List<Object> get props => [standings];
}