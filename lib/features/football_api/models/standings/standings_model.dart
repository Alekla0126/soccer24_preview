import '../paging.dart';
import 'standings.dart';

class StandingsModel {
  final int results;
  final Paging paging;
  final List<Standings> standings;

  StandingsModel({
    required this.results,
    required this.paging,
    required this.standings,
  });

  factory StandingsModel.fromJson(Map<String, dynamic> json) => StandingsModel(
        results: json['results'],
        paging: Paging.fromJson(json['paging']),
        standings: List<Standings>.from(json['response'].map((x) => Standings.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(standings.map((x) => x.toJson())),
      };
}