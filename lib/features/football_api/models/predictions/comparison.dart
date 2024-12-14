import 'comparison_percent.dart';

class Comparison {
  final ComparisonPercent? form;
  final ComparisonPercent? att;
  final ComparisonPercent? def;
  final ComparisonPercent? poissonDistribution;
  final ComparisonPercent? h2H;
  final ComparisonPercent? goals;
  final ComparisonPercent? total;

  Comparison({
    required this.form,
    required this.att,
    required this.def,
    required this.poissonDistribution,
    required this.h2H,
    required this.goals,
    required this.total,
  });

  factory Comparison.fromJson(Map<String, dynamic> json) => Comparison(
        form: json['form'] == null ? null : ComparisonPercent.fromJson(json['form']),
        att: json['att'] == null ? null : ComparisonPercent.fromJson(json['att']),
        def: json['def'] == null ? null : ComparisonPercent.fromJson(json['def']),
        poissonDistribution: json['poisson_distribution'] == null
            ? null
            : ComparisonPercent.fromJson(json['poisson_distribution']),
        h2H: json['h2h'] == null ? null : ComparisonPercent.fromJson(json['h2h']),
        goals: json['goals'] == null ? null : ComparisonPercent.fromJson(json['goals']),
        total: json['total'] == null ? null : ComparisonPercent.fromJson(json['total']),
      );

  Map<String, dynamic> toJson() => {
        'form': form?.toJson(),
        'att': att?.toJson(),
        'def': def?.toJson(),
        'poisson_distribution': poissonDistribution?.toJson(),
        'h2h': h2H?.toJson(),
        'goals': goals?.toJson(),
        'total': total?.toJson(),
      };
}
