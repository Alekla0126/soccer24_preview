
class PlayedGames {
  final int? home;
  final int? away;
  final int? total;

  PlayedGames({
    required this.home,
    required this.away,
    required this.total,
  });

  factory PlayedGames.fromJson(Map<String, dynamic> json) => PlayedGames(
        home: json['home'],
        away: json['away'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'away': away,
        'total': total,
      };
}