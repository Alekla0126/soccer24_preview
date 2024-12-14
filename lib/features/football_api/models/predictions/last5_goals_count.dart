
class Last5GoalsCount {
  final int? total;
  final String? average;

  Last5GoalsCount({
    required this.total,
    required this.average,
  });

  factory Last5GoalsCount.fromJson(Map<String, dynamic> json) => Last5GoalsCount(
        total: json['total'],
        average: json['average'],
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'average': average,
      };
}