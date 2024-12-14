import 'rate_of_total.dart';

class Cards {
  final Map<String, RateOfTotal>? yellow;
  final Map<String, RateOfTotal>? red;

  Cards({
    required this.yellow,
    required this.red,
  });

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
        yellow: json['yellow'] == null
            ? null
            : Map.from(json['yellow'])
                .map((k, v) => MapEntry<String, RateOfTotal>(k, RateOfTotal.fromJson(v))),
        red: json['red'] == null
            ? null
            : Map.from(json['red'])
                .map((k, v) => MapEntry<String, RateOfTotal>(k, RateOfTotal.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        'yellow': Map.from(yellow!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        'red': Map.from(red!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}