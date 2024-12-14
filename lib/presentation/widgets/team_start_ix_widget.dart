import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_cubit.dart';
import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_state.dart';
import '../../features/football_api/models/players_statistics/player_statistics.dart';
import '../../features/football_api/models/lineups/start_xi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'starting_player_widget.dart';


class TeamStartXIWidget extends StatelessWidget {
  const TeamStartXIWidget({
    super.key,
    this.isHomeTeam = true,
  });

  final bool isHomeTeam;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final FixtureLineupsLoadedState lineupsLoadedState =
          context.watch<FixtureLineupsCubit>().state as FixtureLineupsLoadedState;
      int maxMinutes = 0;

      if (lineupsLoadedState.playersStatistics.isNotEmpty) {
        for (final p in lineupsLoadedState.playersStatistics[isHomeTeam ? 0 : 1].players) {
          if (p.statistics[0].games.minutes > maxMinutes) {
            maxMinutes = p.statistics[0].games.minutes;
          }
        }
      }

      final List<StartXi> startXi = lineupsLoadedState.lineups[isHomeTeam ? 0 : 1].startXi;
      final String formation = lineupsLoadedState.lineups[isHomeTeam ? 0 : 1].formation!;

      final List<int> formationAsList = [1, ...formation.split('-').map((e) => int.parse(e))];

      List<Row> linesRows = List<Row>.generate(formationAsList.length, (formationIndex) {
        final List<StartXi> currentLinePlayers = startXi.where((p) {
          return int.parse(p.player!.grid!.split(':').first) == formationIndex + 1;
        }).toList(growable: false);

        List<Widget> playersWidgets =
            List<Widget>.generate(currentLinePlayers.length, (playerIndex) {
          return Builder(builder: (context) {
            PlayerStatistics? playerStatistic;
            int? teamId;
            try {
              if (lineupsLoadedState.playersStatistics.isNotEmpty &&
                  currentLinePlayers[playerIndex].player?.id != null) {
                lineupsLoadedState.playersStatistics[isHomeTeam ? 0 : 1].team.id;

                playerStatistic = lineupsLoadedState.playersStatistics[isHomeTeam ? 0 : 1].players
                    .where((playerStats) {
                  return playerStats.player.id == currentLinePlayers[playerIndex].player?.id;
                }).first;
              }
            } on StateError catch (e) {
              debugPrint(e.message);
            }
            return StartingPlayerWidget(
              widthFactor: currentLinePlayers.length,
              heightFactor: formationAsList.length,
              playerId: currentLinePlayers[playerIndex].player?.id,
              playerName: currentLinePlayers[playerIndex].player?.name,
              playerNumber: currentLinePlayers[playerIndex].player?.number,
              playerStatistic: playerStatistic,
              isSubs: maxMinutes > (playerStatistic?.statistics[0].games.minutes ?? 90),
              teamId: teamId,
            );
          });
        });

        if (!isHomeTeam) {
          playersWidgets = playersWidgets.reversed.toList(growable: false);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: playersWidgets,
        );
      });
      if (!isHomeTeam) {
        linesRows = linesRows.reversed.toList(growable: false);
      }
      return Column(
        children: linesRows,
      );
    });
  }
}
