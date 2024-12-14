import '../../../pin_leagues/models/pinned_league.dart';

class League {
  final int id;
  final String name;
  final String? country;
  final String? flag;
  final int? season;
  final String? round;
  final String? type;

  League({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.season,
    required this.round,
    required this.type,
  });

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json['id'],
        name: json['name'],
        country: json['country'],
        flag: json['flag'],
        season: json['season'],
        round: json['round'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
        // 'logo': logo,
        'flag': flag,
        'season': season,
        'round': round,
        'type': type,
      };

  PinnedLeague toPinned() {
    return PinnedLeague(id: id, name: name);
  }
}
