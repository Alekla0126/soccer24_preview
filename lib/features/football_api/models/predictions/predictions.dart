import 'expected_goals.dart';
import 'prediction_percent.dart';
import 'winner_team.dart';

class Predictions {
  final WinnerTeam? winner;
  final bool? winOrDraw;
  final String? underOver;
  final ExpectedGoals? goals;
  final String? advice;
  final PredictionPercent? percent;

  Predictions({
    required this.winner,
    required this.winOrDraw,
    required this.underOver,
    required this.goals,
    required this.advice,
    required this.percent,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) => Predictions(
        winner: json['winner'] == null ? null : WinnerTeam.fromJson(json['winner']),
        winOrDraw: json['win_or_draw'],
        underOver: json['under_over'],
        goals: json['goals'] == null ? null : ExpectedGoals.fromJson(json['goals']),
        advice: json['advice'],
        percent: json['percent'] == null ? null : PredictionPercent.fromJson(json['percent']),
      );

  Map<String, dynamic> toJson() => {
        'winner': winner?.toJson(),
        'win_or_draw': winOrDraw,
        'under_over': underOver,
        'goals': goals?.toJson(),
        'advice': advice,
        'percent': percent?.toJson(),
      };
}
