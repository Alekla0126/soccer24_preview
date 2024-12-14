import 'fixture_team.dart';
import 'start_xi.dart';
import 'coach.dart';

class FixtureLineup {
  final FixtureTeam? team;
  final Coach? coach;
  final String? formation;
  final List<StartXi> startXi;
  final List<StartXi> substitutes;

  FixtureLineup({
    required this.team,
    required this.coach,
    required this.formation,
    required this.startXi,
    required this.substitutes,
  });

  factory FixtureLineup.fromJson(Map<String, dynamic> json) => FixtureLineup(
        team: json['team'] == null ? null : FixtureTeam.fromJson(json['team']),
        coach: json['coach'] == null ? null : Coach.fromJson(json['coach']),
        formation: json['formation'],
        startXi: json['startXI'] == null
            ? []
            : List<StartXi>.from(json['startXI'].map((x) => StartXi.fromJson(x))),
        substitutes: json['substitutes'] == null
            ? []
            : List<StartXi>.from(json['substitutes'].map((x) => StartXi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'team': team?.toJson(),
        'coach': coach?.toJson(),
        'formation': formation,
        'startXI': List<dynamic>.from(startXi.map((x) => x.toJson())),
        'substitutes': List<dynamic>.from(substitutes.map((x) => x.toJson())),
      };
}