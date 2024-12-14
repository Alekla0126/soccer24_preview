import '../fixture/fixture_details.dart';
import '../fixture/league.dart';
import 'comparison.dart';
import 'prediction_teams.dart';
import 'predictions.dart';

class PredictionsDetails {
  final Predictions? predictions;
  final League? league;
  final TeamsStats? teamsStats;
  final Comparison? comparison;
  final List<FixtureDetails> h2H;

  PredictionsDetails({
    required this.predictions,
    required this.league,
    required this.teamsStats,
    required this.comparison,
    required this.h2H,
  });

  factory PredictionsDetails.fromJson(Map<String, dynamic> json) => PredictionsDetails(
        predictions: json['predictions'] == null ? null : Predictions.fromJson(json['predictions']),
        league: json['league'] == null ? null : League.fromJson(json['league']),
        teamsStats: json['teams'] == null ? null : TeamsStats.fromJson(json['teams']),
        comparison: json['comparison'] == null ? null : Comparison.fromJson(json['comparison']),
        h2H: json['h2h'] == null
            ? []
            : List<FixtureDetails>.from(json['h2h'].map((x) => FixtureDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'predictions': predictions?.toJson(),
        'league': league?.toJson(),
        'teams': teamsStats?.toJson(),
        'comparison': comparison?.toJson(),
        'h2h': List<dynamic>.from(h2H.map((x) => x.toJson())),
      };
}
