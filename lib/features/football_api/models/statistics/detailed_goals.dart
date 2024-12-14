import 'goals_statistics.dart';

class DetailedGoals {
  final GoalsStatistics? goalsFor;
  final GoalsStatistics? goalsAgainst;

  DetailedGoals({
    required this.goalsFor,
    required this.goalsAgainst,
  });

  factory DetailedGoals.fromJson(Map<String, dynamic> json) => DetailedGoals(
        goalsFor: json['for'] == null ? null : GoalsStatistics.fromJson(json['for']),
        goalsAgainst: json['against'] == null ? null : GoalsStatistics.fromJson(json['against']),
      );

  Map<String, dynamic> toJson() => {
        'for': goalsFor?.toJson(),
        'against': goalsAgainst?.toJson(),
      };
}