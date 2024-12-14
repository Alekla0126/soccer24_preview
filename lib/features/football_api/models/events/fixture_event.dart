import '../../../../extensions/enums.dart';
import '../fixture/team.dart';
import 'fixture_event_player.dart';
import 'fixture_event_time.dart';

class FixtureEvent {
  final FixtureEventTime? time;
  final Team? team;
  final FixtureEventPlayer? player;
  final FixtureEventPlayer? assist;
final FixtureEventType? type;
  final FixtureEventDetail? detail;
  final String? comments;

  FixtureEvent({
    required this.time,
    required this.team,
    required this.player,
    required this.assist,
    required this.type,
    required this.detail,
    required this.comments,
  });

  factory FixtureEvent.fromJson(Map<String, dynamic> json) => FixtureEvent(
        time: json['time'] == null ? null : FixtureEventTime.fromJson(json['time']),
        team: json['team'] == null ? null : Team.fromJson(json['team']),
        player: json['player'] == null ? null : FixtureEventPlayer.fromJson(json['player']),
        assist: json['assist'] == null ? null : FixtureEventPlayer.fromJson(json['assist']),
        type: fixtureEventTypeFromString(json['type']),
        detail: eventDetailFromString(json['detail']),
        comments: json['comments'],
      );

  Map<String, dynamic> toJson() => {
        'time': time?.toJson(),
        'team': team?.toJson(),
        'player': player?.toJson(),
        'assist': assist?.toJson(),
        'type': type?.asString,
        'detail': detail?.asString,
        'comments': comments,
      };
}
