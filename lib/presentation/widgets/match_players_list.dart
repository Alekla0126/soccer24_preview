import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_cubit.dart';
import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_state.dart';
import '../../features/football_api/models/players_statistics/player_statistics.dart';
import '../../features/football_api/models/lineups/start_xi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'subs_player_widget.dart';
import 'package:gap/gap.dart';
import 'shadowless_card.dart';


class MatchPlayersList extends StatelessWidget {
  const MatchPlayersList({
    super.key,
    required this.title,
    required this.isSubs,
  });

  final String title;
  final bool isSubs;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final FixtureLineupsLoadedState lineupsLoadedState =
            context.watch<FixtureLineupsCubit>().state as FixtureLineupsLoadedState;

        final List<StartXi> homePlayers;
        final List<StartXi> awayPlayers;

        if (isSubs) {
          homePlayers = lineupsLoadedState.lineups[0].substitutes;
          awayPlayers = lineupsLoadedState.lineups[1].substitutes;
        } else {
          homePlayers = lineupsLoadedState.lineups[0].startXi;
          awayPlayers = lineupsLoadedState.lineups[1].startXi;
        }

        return ShadowlessCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(DefaultValues.padding / 2),
                width: double.infinity,
                color: context.colorScheme.secondaryContainer,
                child: Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Gap(DefaultValues.spacing / 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: List<Widget>.generate(homePlayers.length, (index) {
                        PlayerStatistics? playerStatistic;
                        int? teamId;
                        try {
                          if (lineupsLoadedState.playersStatistics.isNotEmpty &&
                              homePlayers[index].player?.id != null) {
                            teamId = lineupsLoadedState.playersStatistics[0].team.id;
                            playerStatistic =
                                lineupsLoadedState.playersStatistics[0].players.where((element) {
                              return element.player.id == homePlayers[index].player?.id;
                            }).first;
                          }
                        } on StateError catch (e) {
                          debugPrint(e.message);
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: DefaultValues.padding/4),
                          child: SubsPlayerWidget(
                            player: homePlayers[index].player,
                            playerStatistic: playerStatistic,
                            teamId: teamId,
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: List<Widget>.generate(
                        awayPlayers.length,
                        (index) {
                          PlayerStatistics? playerStatistic;
                          int? teamId;
                          try {
                            if (lineupsLoadedState.playersStatistics.isNotEmpty &&
                                awayPlayers[index].player?.id != null) {
                              teamId = lineupsLoadedState.playersStatistics[0].team.id;
                              playerStatistic =
                                  lineupsLoadedState.playersStatistics[1].players.where((element) {
                                return element.player.id == awayPlayers[index].player?.id;
                              }).first;
                            }
                          } on StateError catch (e) {
                            debugPrint(e.message);
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: DefaultValues.padding/4),
                            child: SubsPlayerWidget(
                              player: awayPlayers[index].player,
                              reverse: true,
                              playerStatistic: playerStatistic,
                              teamId: teamId,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}