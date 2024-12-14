class ComparisonPercent {
  final String? home;
  final String? away;

  ComparisonPercent({
    required this.home,
    required this.away,
  });

  factory ComparisonPercent.fromJson(Map<String, dynamic> json) => ComparisonPercent(
        home: json['home'],
        away: json['away'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'away': away,
      };
}
