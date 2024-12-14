import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';

part 'bet_value.g.dart';

@HiveType(typeId: 2)
class BetValue extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String value;
  @HiveField(1)
  final double odd;

  BetValue({
    required this.value,
    required this.odd,
  });

  factory BetValue.fromJson(Map<String, dynamic> json) {
    double odd;
    try {
      odd = json['odd'] is String ? double.parse(json['odd']) : json['odd'].toDouble();
    } catch (_) {
      odd = 1;
    }
    return BetValue(
      value: json['value'].toString(),
      odd: odd,
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'odd': odd,
      };

  @override
  List<Object?> get props => [value, odd];
}