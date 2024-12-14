
class Fixtures {
  final bool events;
  final bool lineups;
  final bool statisticsFixtures;
  final bool statisticsPlayers;

  Fixtures({
    required this.events,
    required this.lineups,
    required this.statisticsFixtures,
    required this.statisticsPlayers,
  });

  factory Fixtures.fromJson(Map<String, dynamic> json) => Fixtures(
        events: json['events'],
        lineups: json['lineups'],
        statisticsFixtures: json['statistics_fixtures'],
        statisticsPlayers: json['statistics_players'],
      );

  Map<String, dynamic> toJson() => {
        'events': events,
        'lineups': lineups,
        'statistics_fixtures': statisticsFixtures,
        'statistics_players': statisticsPlayers,
      };
}