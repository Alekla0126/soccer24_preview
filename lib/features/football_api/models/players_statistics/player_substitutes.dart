class PlayerSubstitutes {
  final int substitutesIn;
  final int out;
  final int bench;

  PlayerSubstitutes({
    required this.substitutesIn,
    required this.out,
    required this.bench,
  });

  factory PlayerSubstitutes.fromJson(Map<String, dynamic> json) =>
      PlayerSubstitutes(
        substitutesIn: json['in'] ?? 0,
        out: json['out'] ?? 0,
        bench: json['bench'] ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {
        'in': substitutesIn,
        'out': out,
        'bench': bench,
      };
}
