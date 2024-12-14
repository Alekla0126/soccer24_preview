class PlayerDribbles {
  final int attempts;
  final int success;
  final int past;

  PlayerDribbles({
    required this.attempts,
    required this.success,
    required this.past,
  });

  factory PlayerDribbles.fromJson(Map<String, dynamic> json) => PlayerDribbles(
        attempts: json['attempts'] ?? 0,
        success: json['success'] ?? 0,
        past: json['past'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'attempts': attempts,
        'success': success,
        'past': past,
      };
}
