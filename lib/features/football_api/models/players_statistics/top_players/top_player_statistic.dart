import '../../players_statistics/player_substitutes.dart';
import '../../players_statistics/player_dribbles.dart';
import '../../players_statistics/player_penalty.dart';
import '../../players_statistics/player_tackles.dart';
import '../../players_statistics/player_passes.dart';
import '../../players_statistics/player_cards.dart';
import '../../players_statistics/player_duels.dart';
import '../../players_statistics/player_fouls.dart';
import '../../players_statistics/player_games.dart';
import '../../players_statistics/player_goals.dart';
import '../../players_statistics/player_shots.dart';
import '../../fixture/league.dart';
import '../../fixture/team.dart';

class TopPlayerStatistic {
  final Team team;
  final League league;
  final PlayerGames games;
  final PlayerSubstitutes substitutes;
  final PlayerShots shots;
  final PlayerGoals goals;
  final PlayerPasses passes;
  final PlayerTackles tackles;
  final PlayerDuels duels;
  final PlayerDribbles dribbles;
  final PlayerFouls fouls;
  final PlayerCards cards;
  final PlayerPenalty penalty;

  TopPlayerStatistic({
    required this.team,
    required this.league,
    required this.games,
    required this.substitutes,
    required this.shots,
    required this.goals,
    required this.passes,
    required this.tackles,
    required this.duels,
    required this.dribbles,
    required this.fouls,
    required this.cards,
    required this.penalty,
  });

  factory TopPlayerStatistic.fromJson(Map<String, dynamic> json) => TopPlayerStatistic(
        team: Team.fromJson(json['team']),
        league: League.fromJson(json['league']),
        games: PlayerGames.fromJson(json['games']),
        substitutes: PlayerSubstitutes.fromJson(json['substitutes']),
        shots: PlayerShots.fromJson(json['shots']),
        goals: PlayerGoals.fromJson(json['goals']),
        passes: PlayerPasses.fromJson(json['passes']),
        tackles: PlayerTackles.fromJson(json['tackles']),
        duels: PlayerDuels.fromJson(json['duels']),
        dribbles: PlayerDribbles.fromJson(json['dribbles']),
        fouls: PlayerFouls.fromJson(json['fouls']),
        cards: PlayerCards.fromJson(json['cards']),
        penalty: PlayerPenalty.fromJson(json['penalty']),
      );
}