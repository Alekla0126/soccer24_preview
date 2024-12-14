import 'last5_goals_count.dart';

class Last5Goals {
  final Last5GoalsCount? goalsFor;
  final Last5GoalsCount? against;

  Last5Goals({
    required this.goalsFor,
    required this.against,
  });

  factory Last5Goals.fromJson(Map<String, dynamic> json) => Last5Goals(
        goalsFor: json['for'] == null ? null : Last5GoalsCount.fromJson(json['for']),
        against: json['against'] == null ? null : Last5GoalsCount.fromJson(json['against']),
      );

  Map<String, dynamic> toJson() => {
        'for': goalsFor?.toJson(),
        'against': against?.toJson(),
      };
}
