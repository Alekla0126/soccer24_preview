import 'last5_goals.dart';

class Last5 {
  final String? form;
  final String? att;
  final String? def;
  final Last5Goals? goals;

  Last5({
    required this.form,
    required this.att,
    required this.def,
    required this.goals,
  });

  factory Last5.fromJson(Map<String, dynamic> json) => Last5(
        form: json['form'],
        att: json['att'],
        def: json['def'],
        goals: json['goals'] == null ? null : Last5Goals.fromJson(json['goals']),
      );

  Map<String, dynamic> toJson() => {
        'form': form,
        'att': att,
        'def': def,
        'goals': goals?.toJson(),
      };
}
