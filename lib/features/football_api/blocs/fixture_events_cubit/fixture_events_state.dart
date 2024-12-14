import '../../models/events/fixture_event.dart';
import '../api_state.dart';

class FixtureEventsLoadedState extends ApiState {
  final List<FixtureEvent> events;

  const FixtureEventsLoadedState({required this.events});

  @override
  List<Object> get props => [events];
}
