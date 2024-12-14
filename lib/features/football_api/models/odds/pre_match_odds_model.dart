import 'pre_match_odds.dart';
import '../paging.dart';

class PreMatchOddsModel {
  final int results;
  final Paging paging;
  final List<PreMatchOdds> preMatchOdds;

  PreMatchOddsModel({
    required this.results,
    required this.paging,
    required this.preMatchOdds,
  });

  factory PreMatchOddsModel.fromJson(Map<String, dynamic> json) => PreMatchOddsModel(
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        preMatchOdds:
            List<PreMatchOdds>.from(json['response'].map((x) => PreMatchOdds.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(preMatchOdds.map((x) => x.toJson())),
      };
}