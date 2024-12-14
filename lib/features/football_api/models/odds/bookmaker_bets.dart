import 'bet.dart';

class BookmakerBets {
  final int id;
  final String name;
  final List<Bet> bets;

  BookmakerBets({
    required this.id,
    required this.name,
    required this.bets,
  });

  factory BookmakerBets.fromJson(Map<String, dynamic> json) => BookmakerBets(
        id: json['id'],
        name: json['name'],
        bets: List<Bet>.from(json['bets'].map((x) => Bet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bets': List<dynamic>.from(bets.map((x) => x.toJson())),
      };
}