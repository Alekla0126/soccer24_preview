part of 'fixtures_cubit.dart';

class FixturesLoadedState extends ApiState {
  final List<FixtureDetails> fixtures;
  final int firstUpcomingIndex;

  const FixturesLoadedState({
    required this.fixtures,
    required this.firstUpcomingIndex,
  });

  @override
  List<Object> get props => [fixtures];
}
