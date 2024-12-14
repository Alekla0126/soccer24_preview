import 'start_xi_player.dart';

class StartXi {
  final StartXiPlayer? player;

  StartXi({
    required this.player,
  });

  factory StartXi.fromJson(Map<String, dynamic> json) => StartXi(
        player: json['player'] == null ? null : StartXiPlayer.fromJson(json['player']),
      );

  Map<String, dynamic> toJson() => {
        'player': player?.toJson(),
      };
}
