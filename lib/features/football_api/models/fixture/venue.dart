
class Venue {
  final int? id;
  final String? name;
  final String? city;

  Venue({
    required this.id,
    required this.name,
    required this.city,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json['id'],
        name: json['name'],
        city: json['city'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
      };
}