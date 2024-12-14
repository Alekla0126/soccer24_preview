
class PlayerGoals {
  final int total;
  final int conceded;
  final int assists;
  final int saves;

  PlayerGoals({
    required this.total,
    required this.conceded,
    required this.assists,
    required this.saves,
  });

  factory PlayerGoals.fromJson(Map<String, dynamic> json) => PlayerGoals(
        total: json['total'] ?? 0,
        conceded: json['conceded'] ?? 0,
        assists: json['assists'] ?? 0,
        saves: json['saves'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'conceded': conceded,
        'assists': assists,
        'saves': saves,
      };
}