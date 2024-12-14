
class PlayerBirth {
  final DateTime? date;
  final String? place;
  final String? country;

  PlayerBirth({
    required this.date,
    required this.place,
    required this.country,
  });

  factory PlayerBirth.fromJson(Map<String, dynamic> json) => PlayerBirth(
        date: DateTime.parse(json['date']),
        place: json['place'],
        country: json['country'],
      );
}