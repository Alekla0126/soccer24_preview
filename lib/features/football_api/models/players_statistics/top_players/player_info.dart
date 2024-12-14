import 'player_birth.dart';

class PlayerInfo {
  final int id;
  final String name;
  final String? firstname;
  final String? lastname;
  final int? age;
  final PlayerBirth? birth;
  final String? nationality;
  final String? height;
  final String? weight;
  final bool injured;

  PlayerInfo({
    required this.id,
    required this.name,
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.birth,
    required this.nationality,
    required this.height,
    required this.weight,
    required this.injured,
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => PlayerInfo(
        id: json['id'],
        name: json['name'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        age: json['age'],
        birth: PlayerBirth.fromJson(json['birth']),
        nationality: json['nationality'],
        height: json['height'],
        weight: json['weight'],
        injured: json['injured'] ?? false,
      );
}