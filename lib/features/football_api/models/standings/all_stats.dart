import 'standing_goals.dart';

class Stats {
  final int? played;
  final int? win;
  final int? draw;
  final int? lose;
  final StandingGoals goals;

  Stats({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goals,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        played: json['played'],
        win: json['win'],
        draw: json['draw'],
        lose: json['lose'],
        goals: StandingGoals.fromJson(json['goals']),
      );

  Map<String, dynamic> toJson() => {
        'played': played,
        'win': win,
        'draw': draw,
        'lose': lose,
        'goals': goals.toJson(),
      };
}