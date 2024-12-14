
class PlayerTackles {
  final int total;
  final int blocks;
  final int interceptions;

  PlayerTackles({
    required this.total,
    required this.blocks,
    required this.interceptions,
  });

  factory PlayerTackles.fromJson(Map<String, dynamic> json) => PlayerTackles(
        total: json['total'] ?? 0,
        blocks: json['blocks'] ?? 0,
        interceptions: json['interceptions'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'blocks': blocks,
        'interceptions': interceptions,
      };
}