import 'player_dribbles.dart';
import 'player_penalty.dart';
import 'player_tackles.dart';
import 'player_passes.dart';
import 'player_cards.dart';
import 'player_duels.dart';
import 'player_fouls.dart';
import 'player_games.dart';
import 'player_goals.dart';
import 'player_shots.dart';

class PlayerStatistic {
  final PlayerGames games;
  final int offsides;
  final PlayerShots shots;
  final PlayerGoals goals;
  final PlayerPasses passes;
  final PlayerTackles tackles;
  final PlayerDuels duels;
  final PlayerDribbles dribbles;
  final PlayerFouls fouls;
  final PlayerCards cards;
  final PlayerPenalty penalty;

  PlayerStatistic({
    required this.games,
    required this.offsides,
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

  factory PlayerStatistic.fromJson(Map<String, dynamic> json) => PlayerStatistic(
        games: PlayerGames.fromJson(json['games']),
        offsides: json['offsides'] ?? 0,
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

  Map<String, dynamic> toJson() => {
        'games': games.toJson(),
        'offsides': offsides,
        'shots': shots.toJson(),
        'goals': goals.toJson(),
        'passes': passes.toJson(),
        'tackles': tackles.toJson(),
        'duels': duels.toJson(),
        'dribbles': dribbles.toJson(),
        'fouls': fouls.toJson(),
        'cards': cards.toJson(),
        'penalty': penalty.toJson(),
      };
}