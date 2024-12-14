import '../../football_api/models/odds/bet_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Tip {
  final String? id;
  final String uid;
  final String? authorName;
  final String? authorPicture;
  final int fixtureId;
  final int fixtureTimestamp;
  final int leagueId;
  final String leagueName;
  final int homeTeamId;
  final String homeTeamName;
  final int awayTeamId;
  final String awayTeamName;
  final int betId;
  final String betName;
  final BetValue betValue;
  final Timestamp shareTime;
  final String? description;
  final int likes;
  final int dislikes;

  bool get isMine => uid == FirebaseAuth.instance.currentUser?.uid;

  Tip({
    this.id,
    required this.uid,
    required this.authorName,
    required this.authorPicture,
    required this.fixtureId,
    required this.fixtureTimestamp,
    required this.leagueId,
    required this.leagueName,
    required this.homeTeamId,
    required this.homeTeamName,
    required this.awayTeamId,
    required this.awayTeamName,
    required this.betId,
    required this.betName,
    required this.betValue,
    required this.shareTime,
    this.description,
    this.likes = 0,
    this.dislikes = 0,
  });

  factory Tip.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Tip.fromJson(snapshot.data() ?? {});
  }

  Tip copyWith({
    String? id,
    String? uid,
    String? authorName,
    String? authorPicture,
    String? description,
  }) {
    return Tip(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      authorName: authorName ?? this.authorName,
      authorPicture: authorPicture ?? this.authorPicture,
      fixtureId: fixtureId,
      fixtureTimestamp: fixtureTimestamp,
      leagueId: leagueId,
      leagueName: leagueName,
      homeTeamId: homeTeamId,
      homeTeamName: homeTeamName,
      awayTeamId: awayTeamId,
      awayTeamName: awayTeamName,
      betId: betId,
      betName: betName,
      betValue: betValue,
      shareTime: shareTime,
      description: description ?? this.description,
      likes: likes,
      dislikes: dislikes,
    );
  }

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      uid: json['uid'],
      authorName: json['authorName'],
      authorPicture: json['authorPicture'],
      fixtureId: json['fixtureId'],
      fixtureTimestamp: json['fixtureTimestamp'],
      leagueId: json['leagueId'],
      leagueName: json['leagueName'],
      homeTeamId: json['homeTeamId'],
      homeTeamName: json['homeTeamName'],
      awayTeamId: json['awayTeamId'],
      awayTeamName: json['awayTeamName'],
      betId: json['betId'],
      betName: json['betName'],
      betValue: BetValue.fromJson(json['betValue']),
      shareTime: json['shareTime'],
      description: json['description'],
      likes: json['likes'],
      dislikes: json['dislikes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'authorName': authorName,
      'authorPicture': authorPicture,
      'fixtureId': fixtureId,
      'fixtureTimestamp': fixtureTimestamp,
      'leagueId': leagueId,
      'leagueName': leagueName,
      'homeTeamId': homeTeamId,
      'homeTeamName': homeTeamName,
      'awayTeamId': awayTeamId,
      'awayTeamName': awayTeamName,
      'betId': betId,
      'betName': betName,
      'betValue': betValue.toJson(),
      'shareTime': shareTime,
      'description': description,
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}