import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/enums.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/standings_cubit/standings_cubit.dart';
import '../../../features/football_api/blocs/standings_cubit/standings_state.dart';
import '../../../features/football_api/repositories/fixtures_repository.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/shadowless_card.dart';
import '../../widgets/standings_table.dart';

class StandingsPage extends StatefulWidget {
  const StandingsPage({super.key, required this.season, required this.leagueId});

  final int season;
  final int leagueId;

  @override
  State<StandingsPage> createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  StandingStatsType statsType = StandingStatsType.all;
  StandingTableType tableType = StandingTableType.short;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StandingsCubit(context.read<FixturesRepository>())
        ..getStandings(
          season: widget.season,
          leagueId: widget.leagueId,
        ),
      child: BlocBuilder<StandingsCubit, ApiState>(
        builder: (context, standingsState) {
          if (standingsState is LoadingState) {
            return const LoadingWidget();
          }
          if (standingsState is ErrorState) {
            return InfoWidget(
              text: standingsState.message,
              icon: soccer24Icons.error,
              color: context.colorScheme.error,
              padding: EdgeInsets.all(DefaultValues.padding),
              buttonText: Strings.retry,
              onButtonTaped: () {
                context.read<StandingsCubit>().getStandings(
                      season: widget.season,
                      leagueId: widget.leagueId,
                    );
              },
            );
          }
          if (standingsState is StandingsLoadedState) {
            if (standingsState.standings.isEmpty) {
              return InfoWidget(
                text: Strings.apiNoStandings,
                icon: soccer24Icons.empty,
                color: context.colorScheme.secondaryContainer,
                padding: EdgeInsets.all(DefaultValues.padding),
              );
            }

            final standings = standingsState.standings[0].league.standings;

            final List<Widget> tables = List<Widget>.generate(
              standings.length,
              (index) {
                return ShadowlessCard(
                  child: Padding(
                    padding: EdgeInsets.all(DefaultValues.padding / 2),
                    child: StandingsTable(
                      standings: standings[index],
                      leagueId: standingsState.standings[0].league.id,
                      leagueName: standingsState.standings[0].league.name,
                      flag: standingsState.standings[0].league.flag,
                      statsType: statsType,
                      tableType: tableType,
                    ),
                  ),
                );
              },
            );

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(DefaultValues.padding/2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List<Widget>.generate(
                              StandingStatsType.values.length,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: DefaultValues.padding / 4),
                                  child: ChoiceChip(
                                    padding: EdgeInsets.zero,
                                    label: Text(
                                      StandingStatsType.values[index].name.toUpperCase(),
                                      style: context.textTheme.labelSmall,
                                    ),
                                    selected: StandingStatsType.values[index] == statsType,
                                    showCheckmark: false,
                                    onSelected: (selected) {
                                      if (!selected) return;
                                      setState(() {
                                        statsType = StandingStatsType.values[index];
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List<Widget>.generate(
                              StandingTableType.values.length,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: DefaultValues.padding / 4),
                                  child: ChoiceChip(
                                    padding: EdgeInsets.zero,
                                    label: Text(
                                      StandingTableType.values[index].name.toUpperCase(),
                                      style: context.textTheme.labelSmall,
                                    ),
                                    selected: StandingTableType.values[index] == tableType,
                                    showCheckmark: false,
                                    onSelected: (selected) {
                                      if (!selected) return;
                                      setState(() {
                                        tableType = StandingTableType.values[index];
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...tables,
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
              context.read<StandingsCubit>().getStandings(
                    season: widget.season,
                    leagueId: widget.leagueId,
                  );
            },
          );
        },
      ),
    );
  }
}
