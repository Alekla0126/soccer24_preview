class Streak {
  final int? wins;
  final int? draws;
  final int? loses;

  Streak({
    required this.wins,
    required this.draws,
    required this.loses,
  });

  factory Streak.fromJson(Map<String, dynamic> json) => Streak(
        wins: json['wins'],
        draws: json['draws'],
        loses: json['loses'],
      );

  Map<String, dynamic> toJson() => {
        'wins': wins,
        'draws': draws,
        'loses': loses,
      };
}
