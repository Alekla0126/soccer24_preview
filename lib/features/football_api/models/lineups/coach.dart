
class Coach {
  final int? id;
  final String? name;

  Coach({
    required this.id,
    required this.name,
  });

  factory Coach.fromJson(Map<String, dynamic> json) => Coach(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}