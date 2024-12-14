
class PlayerPasses {
  final int total;
  final int key;
  final dynamic accuracy;

  PlayerPasses({
    required this.total,
    required this.key,
    required this.accuracy,
  });

  factory PlayerPasses.fromJson(Map<String, dynamic> json) => PlayerPasses(
        total: json['total'] ?? 0,
        key: json['key'] ?? 0,
        accuracy: (json['accuracy'] ?? '0').toString(),
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'key': key,
        'accuracy': accuracy,
      };
}