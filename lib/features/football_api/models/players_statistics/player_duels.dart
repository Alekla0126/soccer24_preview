class PlayerDuels {
  final int total;
  final int won;

  PlayerDuels({
    required this.total,
    required this.won,
  });

  factory PlayerDuels.fromJson(Map<String, dynamic> json) => PlayerDuels(
        total: json['total'] ?? 0,
        won: json['won'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'won': won,
      };
}
