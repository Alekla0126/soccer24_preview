import 'rate_of_total.dart';

class TotalPenalties {
  final RateOfTotal? scored;
  final RateOfTotal? missed;
  final int? total;

  TotalPenalties({
    required this.scored,
    required this.missed,
    required this.total,
  });

  factory TotalPenalties.fromJson(Map<String, dynamic> json) => TotalPenalties(
        scored: json['scored'] == null ? null : RateOfTotal.fromJson(json['scored']),
        missed: json['missed'] == null ? null : RateOfTotal.fromJson(json['missed']),
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'scored': scored?.toJson(),
        'missed': missed?.toJson(),
        'total': total,
      };
}
