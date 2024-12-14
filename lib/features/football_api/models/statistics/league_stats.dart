import 'biggest_results.dart';
import 'cards.dart';
import 'detailed_goals.dart';
import 'games_per_lineup.dart';
import 'played_games.dart';
import 'team_fixtures.dart';
import 'total_penalties.dart';

class LeagueStats {
  final String? form;
  final TeamFixtures? fixtures;
  final DetailedGoals? goals;
  final BiggestResults? biggest;
  final PlayedGames? cleanSheet;
  final PlayedGames? failedToScore;
  final TotalPenalties? penalty;
  final List<GamesPerLineup?> lineups;
  final Cards? cards;

  LeagueStats({
    required this.form,
    required this.fixtures,
    required this.goals,
    required this.biggest,
    required this.cleanSheet,
    required this.failedToScore,
    required this.penalty,
    required this.lineups,
    required this.cards,
  });

  factory LeagueStats.fromJson(Map<String, dynamic> json) => LeagueStats(
        form: json['form'],
        fixtures: (json['fixtures'] == null) ? null : TeamFixtures.fromJson(json['fixtures']),
        goals: (json['goals'] == null) ? null : DetailedGoals.fromJson(json['goals']),
        biggest: (json['biggest'] == null) ? null : BiggestResults.fromJson(json['biggest']),
        cleanSheet:
            (json['clean_sheet'] == null) ? null : PlayedGames.fromJson(json['clean_sheet']),
        failedToScore: (json['failed_to_score'] == null)
            ? null
            : PlayedGames.fromJson(json['failed_to_score']),
        penalty: (json['penalty'] == null) ? null : TotalPenalties.fromJson(json['penalty']),
        lineups: json['lineups'] == null
            ? []
            : List<GamesPerLineup>.from(json['lineups'].map((x) => GamesPerLineup.fromJson(x))),
        cards: json['cards'] == null ? null : Cards.fromJson(json['cards']),
      );

  Map<String, dynamic> toJson() => {
        'form': form,
        'fixtures': fixtures?.toJson(),
        'goals': goals?.toJson(),
        'biggest': biggest?.toJson(),
        'clean_sheet': cleanSheet?.toJson(),
        'failed_to_score': failedToScore?.toJson(),
        'penalty': penalty?.toJson(),
        'lineups': List<dynamic>.from(lineups.map((x) => x?.toJson())),
        'cards': cards?.toJson(),
      };
}
