import 'fixtures.dart';

class Coverage {
  final Fixtures fixtures;
  final bool standings;
  final bool players;
  final bool topScorers;
  final bool topAssists;
  final bool topCards;
  final bool injuries;
  final bool predictions;
  final bool odds;

  Coverage({
    required this.fixtures,
    required this.standings,
    required this.players,
    required this.topScorers,
    required this.topAssists,
    required this.topCards,
    required this.injuries,
    required this.predictions,
    required this.odds,
  });

  factory Coverage.fromJson(Map<String, dynamic> json) => Coverage(
        fixtures: Fixtures.fromJson(json['fixtures']),
        standings: json['standings'],
        players: json['players'],
        topScorers: json['top_scorers'],
        topAssists: json['top_assists'],
        topCards: json['top_cards'],
        injuries: json['injuries'],
        predictions: json['predictions'],
        odds: json['odds'],
      );

  Map<String, dynamic> toJson() => {
        'fixtures': fixtures.toJson(),
        'standings': standings,
        'players': players,
        'top_scorers': topScorers,
        'top_assists': topAssists,
        'top_cards': topCards,
        'injuries': injuries,
        'predictions': predictions,
        'odds': odds,
      };
}
