
class Goals {
  final int? home;
  final int? away;

  Goals({
    required this.home,
    required this.away,
  });

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        home: json['home'],
        away: json['away'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'away': away,
      };
}