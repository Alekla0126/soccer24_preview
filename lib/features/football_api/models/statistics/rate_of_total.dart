
class RateOfTotal {
  final int? total;
  final String? percentage;

  RateOfTotal({
    required this.total,
    required this.percentage,
  });

  factory RateOfTotal.fromJson(Map<String, dynamic> json) => RateOfTotal(
        total: json['total'],
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'percentage': percentage,
      };
}