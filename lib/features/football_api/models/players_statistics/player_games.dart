import '../../../../extensions/enums.dart';

class PlayerGames {
  final int minutes;
  final int number;
  final PlayerPosition? position;
  final String? rating;
  final bool captain;
  final bool substitute;
  final int appearences;
  final int lineups;

  PlayerGames({
    required this.minutes,
    required this.number,
    required this.position,
    required this.rating,
    required this.captain,
    required this.substitute,
    required this.appearences,
    required this.lineups,
  });

  factory PlayerGames.fromJson(Map<String, dynamic> json) => PlayerGames(
        minutes: json['minutes'] ?? 0,
        number: json['number'] ?? 0,
        position: playerPositionShortFromString(json['position']),
        rating: json['rating'],
        captain: json['captain'] ?? false,
        substitute: json['substitute'] ?? false,
        appearences: json['appearences'] ?? 0,
        lineups: json['lineups'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'minutes': minutes,
        'number': number,
        'position': position?.shortName,
        'rating': rating,
        'captain': captain,
        'substitute': substitute,
      };
}