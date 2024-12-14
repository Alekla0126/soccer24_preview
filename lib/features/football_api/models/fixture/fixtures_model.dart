import 'fixture_details.dart';
import '../paging.dart';

class FixturesResponse {
  final int results;
  final Paging paging;
  final List<FixtureDetails> fixtures;

  FixturesResponse({
    required this.results,
    required this.paging,
    required this.fixtures,
  });

  factory FixturesResponse.fromJson(Map<String, dynamic> json) => FixturesResponse(
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        fixtures:
            List<FixtureDetails>.from(json['response'].map((x) => FixtureDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(fixtures.map((x) => x.toJson())),
      };
}