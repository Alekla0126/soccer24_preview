import 'package:cloud_firestore/cloud_firestore.dart';

import 'fixture.dart';
import 'goals.dart';
import 'league.dart';
import 'score.dart';
import 'teams.dart';

class FixtureDetails {
  final Fixture fixture;
  final League league;
  final Teams teams;
  final Goals goals;
  final Score score;

  FixtureDetails({
    required this.fixture,
    required this.league,
    required this.teams,
    required this.goals,
    required this.score,
  });

  factory FixtureDetails.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snap) {
    return FixtureDetails.fromJson(snap.data() ?? {});
  }

  factory FixtureDetails.fromJson(Map<String, dynamic> json) => FixtureDetails(
        fixture: Fixture.fromJson(json['fixture']),
        league: League.fromJson(json['league']),
        teams: Teams.fromJson(json['teams']),
        goals: Goals.fromJson(json['goals']),
        score: Score.fromJson(json['score']),
      );

  Map<String, dynamic> toJson() => {
        'fixture': fixture.toJson(),
        'league': league.toJson(),
        'teams': teams.toJson(),
        'goals': goals.toJson(),
        'score': score.toJson(),
      };

  @override
  String toString() {
    return '${fixture.id} => ${teams.home.name} vs ${teams.away.name}';
  }
}
