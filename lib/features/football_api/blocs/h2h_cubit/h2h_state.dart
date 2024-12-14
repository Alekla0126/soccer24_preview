import '../../models/fixture/fixture_details.dart';
import '../api_state.dart';

class H2HLoadedState extends ApiState {
  final List<FixtureDetails> fixtures;

  const H2HLoadedState({required this.fixtures});

  @override
  List<Object> get props => [fixtures];
}
