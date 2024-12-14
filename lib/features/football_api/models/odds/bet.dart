import 'bet_value.dart';

class Bet {
  final int id;
  final String name;
  final List<BetValue> values;

  Bet({
    required this.id,
    required this.name,
    this.values = const [],
  });

  factory Bet.fromJson(Map<String, dynamic> json) => Bet(
        id: json['id'],
        name: json['name'],
        values: List<BetValue>.from(json['values'].map((x) => BetValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'values': List<dynamic>.from(values.map((x) => x.toJson())),
      };
}
