import 'fixture_lineup.dart';
import '../paging.dart';

class FixturesLineupsModel {
  final int resultsCount;
  final Paging paging;
  final List<FixtureLineup> lineups;

  FixturesLineupsModel({
    required this.resultsCount,
    required this.paging,
    required this.lineups,
  });

  factory FixturesLineupsModel.fromJson(Map<String, dynamic> json) => FixturesLineupsModel(
        resultsCount: json['results'],
        paging: Paging.fromJson(json['paging']),
        lineups: List<FixtureLineup>.from(json['response'].map((x) => FixtureLineup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': resultsCount,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(lineups.map((x) => x.toJson())),
      };
}