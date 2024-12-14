import '../../models/statistics/team_statistic.dart';
import '../api_state.dart';

class FixtureStatisticsLoadedState extends ApiState {
  final List<TeamStatistic> teamStatistics;

  const FixtureStatisticsLoadedState({required this.teamStatistics});

  @override
  List<Object> get props => [teamStatistics];
}