import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_cubit.dart';
import '../../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_state.dart';
import '../../widgets/coach_widget.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/match_players_list.dart';
import '../../widgets/match_start_xi_field.dart';

class LineupsPage extends StatelessWidget {
  const LineupsPage({
    super.key,
    required this.fixtureId,
    required this.timestamp,
  });

  final int fixtureId;
  final int timestamp;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixtureLineupsCubit, ApiState>(
      builder: (context, lineupsState) {
        if (lineupsState is LoadingState) {
          return const LoadingWidget();
        }
        if (lineupsState is ErrorState) {
          return InfoWidget(
            text: lineupsState.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () {
              context.read<FixtureLineupsCubit>().getFixtureLineups(
                    fixtureId: fixtureId,
                    getPlayersStats: timestamp < DateTime.now().millisecondsSinceEpoch / 1000,
                  );
            },
          );
        }
        if (lineupsState is FixtureLineupsLoadedState) {
          if (lineupsState.lineups.length < 2) {
            return InfoWidget(
              text: Strings.apiNoLineups,
              icon: soccer24Icons.empty,
              color: context.colorScheme.secondaryContainer,
              padding: EdgeInsets.all(DefaultValues.padding),
            );
          }
          final bool canShowField = lineupsState.lineups[0].formation != null &&
              lineupsState.lineups[1].formation != null;

          return SingleChildScrollView(
            child: Column(
              children: [
                //Home team coach
                CoachWidget(lineup: lineupsState.lineups[0]),
                //Start XI
                SizedBox(
                  child: canShowField
                      ? const MatchStartXIField()
                      : const MatchPlayersList(
                          title: Strings.startXI,
                          isSubs: false,
                        ),
                ),
                //Away team coach
                CoachWidget(lineup: lineupsState.lineups[1], isHomeTeam: false),
                //Substitution
                const MatchPlayersList(
                  title: Strings.substitutes,
                  isSubs: true,
                ),
              ],
            ),
          );
        }

        return InfoWidget(
          text: Strings.somethingWentWrong,
          icon: soccer24Icons.error,
          color: context.colorScheme.error,
          padding: EdgeInsets.all(DefaultValues.padding),
          buttonText: Strings.retry,
          onButtonTaped: () {
            context.read<FixtureLineupsCubit>().getFixtureLineups(
                  fixtureId: fixtureId,
                  getPlayersStats: timestamp < DateTime.now().millisecondsSinceEpoch / 1000,
                );
          },
        );
      },
    );
  }
}
