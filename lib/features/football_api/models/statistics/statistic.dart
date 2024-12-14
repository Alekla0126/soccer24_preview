
class Statistic {
  final String type;
  final dynamic value;

  Statistic({
    required this.type,
    required this.value,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        type: json['type'],
        value: json['value'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };
}