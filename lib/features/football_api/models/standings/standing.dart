import '../fixture/team.dart';
import 'all_stats.dart';

class Standing {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final String group;
  final String? form;
  final String? status;
  final String? description;
  final Stats all;
  final Stats home;
  final Stats away;
  final DateTime update;

  Standing({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.group,
    required this.form,
    required this.status,
    required this.description,
    required this.all,
    required this.home,
    required this.away,
    required this.update,
  });

  factory Standing.fromJson(Map<String, dynamic> json) => Standing(
        rank: json['rank'],
        team: Team.fromJson(json['team']),
        points: json['points'],
        goalsDiff: json['goalsDiff'],
        group: json['group'],
        form: json['form'],
        status: json['status'],
        description: json['description'],
        all: Stats.fromJson(json['all']),
        home: Stats.fromJson(json['home']),
        away: Stats.fromJson(json['away']),
        update: DateTime.parse(json['update']),
      );

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'team': team.toJson(),
        'points': points,
        'goalsDiff': goalsDiff,
        'group': group,
        'form': form,
        'status': status,
        'description': description,
        'all': all.toJson(),
        'home': home.toJson(),
        'away': away.toJson(),
        'update': update.toIso8601String(),
      };
}