import 'biggest_scored_goals.dart';

class BiggestGoals {
  final BiggestScoredGoals? goalsFor;
  final BiggestScoredGoals? against;

  BiggestGoals({
    required this.goalsFor,
    required this.against,
  });

  factory BiggestGoals.fromJson(Map<String, dynamic> json) => BiggestGoals(
        goalsFor: json['for'] == null ? null : BiggestScoredGoals.fromJson(json['for']),
        against: json['against'] == null ? null : BiggestScoredGoals.fromJson(json['against']),
      );

  Map<String, dynamic> toJson() => {
        'for': goalsFor?.toJson(),
        'against': against?.toJson(),
      };
}
