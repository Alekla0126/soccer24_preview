
class Paging {
  final int current;
  final int total;

  Paging({
    required this.current,
    required this.total,
  });

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        current: json['current'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current': current,
        'total': total,
      };
}