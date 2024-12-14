import '../../../../extensions/enums.dart';

class StartXiPlayer {
  final int? id;
  final String? name;
  final int? number;
  final PlayerPosition? pos;
  final String? grid;

  StartXiPlayer({
    required this.id,
    required this.name,
    required this.number,
    required this.pos,
    required this.grid,
  });

  factory StartXiPlayer.fromJson(Map<String, dynamic> json) => StartXiPlayer(
        id: json['id'],
        name: json['name'],
        number: json['number'],
        pos: playerPositionShortFromString(json['pos']),
        grid: json['grid'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'pos': pos?.shortName,
        'grid': grid,
      };
}
