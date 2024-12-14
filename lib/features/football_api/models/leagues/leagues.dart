import '../paging.dart';
import 'league_model.dart';

class Leagues {
  final int results;
  final Paging paging;
  final List<LeagueModel> leagues;

  Leagues({
    required this.results,
    required this.paging,
    required this.leagues,
  });

  factory Leagues.fromJson(Map<String, dynamic> json) => Leagues(
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        leagues: List<LeagueModel>.from(json['response'].map((x) => LeagueModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(leagues.map((x) => x.toJson())),
      };
}
