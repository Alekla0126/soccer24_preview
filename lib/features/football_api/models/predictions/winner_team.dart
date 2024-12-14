class WinnerTeam {
  final int? id;
  final String? name;
  final String? comment;

  WinnerTeam({
    required this.id,
    required this.name,
    required this.comment,
  });

  factory WinnerTeam.fromJson(Map<String, dynamic> json) => WinnerTeam(
        id: json['id'],
        name: json['name'],
        comment: json['comment'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'comment': comment,
      };
}
