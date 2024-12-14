class StandingGoals {
  final int? goalsFor;
  final int? against;

  StandingGoals({
    required this.goalsFor,
    required this.against,
  });

  factory StandingGoals.fromJson(Map<String, dynamic> json) => StandingGoals(
        goalsFor: json['for'],
        against: json['against'],
      );

  Map<String, dynamic> toJson() => {
        'for': goalsFor,
        'against': against,
      };
}
