import 'fixture_event.dart';
import '../paging.dart';

class FixtureEvents {
  final int resultsCount;
  final Paging paging;
  final List<FixtureEvent> events;

  FixtureEvents({
    required this.resultsCount,
    required this.paging,
    required this.events,
  });

  factory FixtureEvents.fromJson(Map<String, dynamic> json) => FixtureEvents(
        resultsCount: json['results'],
        paging: Paging.fromJson(json['paging']),
        events: List<FixtureEvent>.from(json['response'].map((x) => FixtureEvent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': resultsCount,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(events.map((x) => x.toJson())),
      };
}