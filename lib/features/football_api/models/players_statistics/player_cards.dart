
class PlayerCards {
  final int yellow;
  final int yellowred;
  final int red;

  PlayerCards({
    required this.yellow,
    required this.yellowred,
    required this.red,
  });

  factory PlayerCards.fromJson(Map<String, dynamic> json) => PlayerCards(
        yellow: json['yellow'] ?? 0,
        yellowred: json['yellowred'] ?? 0,
        red: json['red'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'yellow': yellow,
        'yellowred': yellowred,
        'red': red,
      };
}