class PlayerShots {
  final int total;
  final int on;

  PlayerShots({
    required this.total,
    required this.on,
  });

  factory PlayerShots.fromJson(Map<String, dynamic> json) => PlayerShots(
        total: json['total'] ?? 0,
        on: json['on'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'on': on,
      };
}
