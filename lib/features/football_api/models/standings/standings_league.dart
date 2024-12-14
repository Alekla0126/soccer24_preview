import 'standing.dart';

class StandingsLeague {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String? flag;
  final int season;
  final List<List<Standing>> standings;

  StandingsLeague({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.flag,
    required this.season,
    required this.standings,
  });

  factory StandingsLeague.fromJson(Map<String, dynamic> json) => StandingsLeague(
        id: json['id'],
        name: json['name'],
        country: json['country'],
        logo: json['logo'],
        flag: json['flag'],
        season: json['season'],
        standings: List<List<Standing>>.from(
            json['standings'].map((x) => List<Standing>.from(x.map((x) => Standing.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
        'logo': logo,
        'flag': flag,
        'season': season,
        'standings':
            List<dynamic>.from(standings.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}
