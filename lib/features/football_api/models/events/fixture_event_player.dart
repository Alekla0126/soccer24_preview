class FixtureEventPlayer {
  final int? id;
  final String? name;

  FixtureEventPlayer({
    required this.id,
    required this.name,
  });

  factory FixtureEventPlayer.fromJson(Map<String, dynamic> json) => FixtureEventPlayer(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
