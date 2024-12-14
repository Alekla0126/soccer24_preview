import 'biggest_goals.dart';
import 'streak.dart';
import 'team_biggest_results.dart';

class BiggestResults {
  final Streak? streak;
  final TeamBiggestResults? wins;
  final TeamBiggestResults? loses;
  final BiggestGoals? goals;

  BiggestResults({
    required this.streak,
    required this.wins,
    required this.loses,
    required this.goals,
  });

  factory BiggestResults.fromJson(Map<String, dynamic> json) => BiggestResults(
        streak: json['streak'] == null ? null : Streak.fromJson(json['streak']),
        wins: json['wins'] == null ? null : TeamBiggestResults.fromJson(json['wins']),
        loses: json['loses'] == null ? null : TeamBiggestResults.fromJson(json['loses']),
        goals: json['goals'] == null ? null : BiggestGoals.fromJson(json['goals']),
      );

  Map<String, dynamic> toJson() => {
        'streak': streak?.toJson(),
        'wins': wins?.toJson(),
        'loses': loses?.toJson(),
        'goals': goals?.toJson(),
      };
}
