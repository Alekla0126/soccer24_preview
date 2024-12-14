import '../fixture/league.dart';
import 'country.dart';
import 'season.dart';

class LeagueModel {
  final League league;
  final Country country;
  final List<Season> seasons;

  LeagueModel({
    required this.league,
    required this.country,
    required this.seasons,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) => LeagueModel(
        league: League.fromJson(json['league']),
        country: Country.fromJson(json['country']),
        seasons: List<Season>.from(json['seasons'].map((x) => Season.fromJson(x))),
      );



  Map<String, dynamic> toJson() => {
        'league': league.toJson(),
        'country': country.toJson(),
        'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
      };

}
