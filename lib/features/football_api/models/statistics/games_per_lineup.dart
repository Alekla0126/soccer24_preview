class GamesPerLineup {
  final String? formation;
  final int? played;

  GamesPerLineup({
    required this.formation,
    required this.played,
  });

  factory GamesPerLineup.fromJson(Map<String, dynamic> json) => GamesPerLineup(
        formation: json['formation'],
        played: json['played'],
      );

  Map<String, dynamic> toJson() => {
        'formation': formation,
        'played': played,
      };
}
