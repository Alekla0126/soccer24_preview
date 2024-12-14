class PredictionPercent {
  final String? home;
  final String? draw;
  final String? away;

  PredictionPercent({
    required this.home,
    required this.draw,
    required this.away,
  });

  factory PredictionPercent.fromJson(Map<String, dynamic> json) => PredictionPercent(
        home: json['home'],
        draw: json['draw'],
        away: json['away'],
      );

  Map<String, dynamic> toJson() => {
        'home': home,
        'draw': draw,
        'away': away,
      };
}
