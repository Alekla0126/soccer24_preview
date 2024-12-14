
class BiggestScoredGoals {
  final int? home;
  final int? away;

  BiggestScoredGoals({
    required this.home,
    required this.away,
  });

  factory BiggestScoredGoals.fromJson(Map<String, dynamic> json) => BiggestScoredGoals(
        home: json['home'],
        away: json['away'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'away': away,
      };
}