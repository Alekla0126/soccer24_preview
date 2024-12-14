import 'team_colors.dart';

class FixtureTeam {
  final int? id;
  final String? name;
  final TeamColors? colors;
  final String? update;
  final bool? winner;

  FixtureTeam({
    required this.id,
    required this.name,
    required this.colors,
    required this.update,
    required this.winner,
  });

  factory FixtureTeam.fromJson(Map<String, dynamic> json) => FixtureTeam(
        id: json['id'],
        name: json['name'],
        colors: json['colors'] == null ? null : TeamColors.fromJson(json['colors']),
        update: json['update'],
        winner: json['winner'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colors': colors,
        'update': update,
        'winner': winner,
      };
}
