import 'package:cloud_firestore/cloud_firestore.dart';
import '../fixture/league.dart';
import 'bookmaker_bets.dart';
import 'odds_fixture.dart';


class PreMatchOdds {
  final League league;
  final OddsFixture fixture;
  final DateTime update;
  final List<BookmakerBets> bookmakers;

  PreMatchOdds({
    required this.league,
    required this.fixture,
    required this.update,
    required this.bookmakers,
  });

  factory PreMatchOdds.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return PreMatchOdds.fromJson(snapshot.data() ?? {});
  }

  factory PreMatchOdds.fromJson(Map<String, dynamic> json) => PreMatchOdds(
        league: League.fromJson(json['league']),
        fixture: OddsFixture.fromJson(json['fixture']),
        update: DateTime.parse(json['update']),
        bookmakers:
            List<BookmakerBets>.from(json['bookmakers'].map((x) => BookmakerBets.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'league': league.toJson(),
        'fixture': fixture.toJson(),
        'update': update.toIso8601String(),
        'bookmakers': List<dynamic>.from(bookmakers.map((x) => x.toJson())),
      };
}