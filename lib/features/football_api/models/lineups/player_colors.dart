
class PlayerColors {
  final String? primary;
  final String? number;
  final String? border;

  PlayerColors({
    required this.primary,
    required this.number,
    required this.border,
  });

  factory PlayerColors.fromJson(Map<String, dynamic> json) => PlayerColors(
        primary: json['primary'],
        number: json['number'],
        border: json['border'],
      );

  Map<String, dynamic> toJson() => {
        'primary': primary,
        'number': number,
        'border': border,
      };
}