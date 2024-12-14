class PlayerFouls {
  final int drawn;
  final int committed;

  PlayerFouls({
    required this.drawn,
    required this.committed,
  });

  factory PlayerFouls.fromJson(Map<String, dynamic> json) => PlayerFouls(
        drawn: json['drawn'] ?? 0,
        committed: json['committed'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'drawn': drawn,
        'committed': committed,
      };
}
