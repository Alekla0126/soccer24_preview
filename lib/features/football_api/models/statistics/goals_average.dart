class GoalsAverage {
  final String? home;
  final String? away;
  final String? total;

  GoalsAverage({
    required this.home,
    required this.away,
    required this.total,
  });

  factory GoalsAverage.fromJson(Map<String, dynamic> json) => GoalsAverage(
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
