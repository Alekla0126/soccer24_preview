
class PlayerPenalty {
  final int won;
  final int commited;
  final int scored;
  final int missed;
  final int saved;

  PlayerPenalty({
    required this.won,
    required this.commited,
    required this.scored,
    required this.missed,
    required this.saved,
  });

  factory PlayerPenalty.fromJson(Map<String, dynamic> json) => PlayerPenalty(
        won: json['won'] ?? 0,
        commited: json['commited'] ?? 0,
        scored: json['scored'] ?? 0,
        missed: json['missed'] ?? 0,
        saved: json['saved'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'won': won,
        'commited': commited,
        'scored': scored,
        'missed': missed,
        'saved': saved,
      };
}