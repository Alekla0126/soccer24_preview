import 'goals.dart';

class Score {
  final Goals halftime;
  final Goals fulltime;
  final Goals extratime;
  final Goals penalty;

  Score({
    required this.halftime,
    required this.fulltime,
    required this.extratime,
    required this.penalty,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        halftime: Goals.fromJson(json['halftime']),
        fulltime: Goals.fromJson(json['fulltime']),
        extratime: Goals.fromJson(json['extratime']),
        penalty: Goals.fromJson(json['penalty']),
      );

  Map<String, dynamic> toJson() => {
        'halftime': halftime.toJson(),
        'fulltime': fulltime.toJson(),
        'extratime': extratime.toJson(),
        'penalty': penalty.toJson(),
      };
}