import 'player_colors.dart';

class TeamColors {
  final PlayerColors? player;
  final PlayerColors? goalkeeper;

  TeamColors({
    required this.player,
    required this.goalkeeper,
  });

  factory TeamColors.fromJson(Map<String, dynamic> json) => TeamColors(
        player: json['player'] == null ? null : PlayerColors.fromJson(json['player']),
        goalkeeper: json['goalkeeper'] == null ? null : PlayerColors.fromJson(json['goalkeeper']),
      );

  Map<String, dynamic> toJson() => {
        'player': player?.toJson(),
        'goalkeeper': goalkeeper?.toJson(),
      };
}
