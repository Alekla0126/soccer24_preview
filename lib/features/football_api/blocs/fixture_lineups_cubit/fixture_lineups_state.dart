import '../../models/players_statistics/players_statistic.dart';
import '../../models/lineups/fixture_lineup.dart';
import '../api_state.dart';

class FixtureLineupsLoadedState extends ApiState {
  final List<FixtureLineup> lineups;
  final List<PlayersStatistic> playersStatistics;

  const FixtureLineupsLoadedState({required this.playersStatistics, required this.lineups});

  @override
  List<Object> get props => [lineups, playersStatistics];
}