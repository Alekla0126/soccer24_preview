
class Periods {
  final int? first;
  final int? second;

  Periods({
    required this.first,
    required this.second,
  });

  factory Periods.fromJson(Map<String, dynamic> json) => Periods(
        first: json['first'],
        second: json['second'],
      );

  Map<String, dynamic> toJson() => {
        'first': first,
        'second': second,
      };
}