part of 'fixture_cubit.dart';

class FixtureLoadedState extends ApiState {
  final FixtureDetails fixture;

  const FixtureLoadedState({required this.fixture});

  @override
  List<Object> get props => [fixture];
}
