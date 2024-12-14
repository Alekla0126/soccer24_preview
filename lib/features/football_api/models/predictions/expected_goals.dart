
class ExpectedGoals {
  final String? home;
  final String? away;

  ExpectedGoals({
    required this.home,
    required this.away,
  });

  factory ExpectedGoals.fromJson(Map<String, dynamic> json) => ExpectedGoals(
        home: json['home'],
        away: json['away'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'away': away,
      };
}