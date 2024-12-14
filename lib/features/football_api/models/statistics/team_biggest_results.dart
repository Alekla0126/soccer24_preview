
class TeamBiggestResults {
  final String? home;
  final String? away;

  TeamBiggestResults({
    required this.home,
    required this.away,
  });

  factory TeamBiggestResults.fromJson(Map<String, dynamic> json) => TeamBiggestResults(
        home: json['home'],
        away: json['away'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'away': away,
      };
}