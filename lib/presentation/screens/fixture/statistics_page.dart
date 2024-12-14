import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixture_statistics_cubit/fixture_statistics_cubit.dart';
import '../../../features/football_api/blocs/fixture_statistics_cubit/fixture_statistics_state.dart';
import '../../../features/football_api/models/statistics/statistic.dart';
import '../../../features/football_api/models/statistics/team_statistic.dart';
import '../../widgets/compare_widget.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key, required this.fixtureId});

  final int fixtureId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixtureStatisticsCubit, ApiState>(
      builder: (context, statisticsState) {
        if (statisticsState is LoadingState) {
          return const LoadingWidget();
        }
        if (statisticsState is ErrorState) {
          return InfoWidget(
            text: statisticsState.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () {
              context.read<FixtureStatisticsCubit>().getFixtureStatistics(
                    fixtureId: fixtureId,
                  );
            },
          );
        }
        if (statisticsState is FixtureStatisticsLoadedState) {
          final List<TeamStatistic> teamStatistics = statisticsState.teamStatistics;

          if (teamStatistics.isEmpty) {
            return InfoWidget(
              text: Strings.apiNoTeamStatistics,
              icon: soccer24Icons.empty,
              color: context.colorScheme.secondaryContainer,
              padding: EdgeInsets.all(DefaultValues.padding),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            child: Column(
              children: List<Widget>.generate(Strings.statisticsTypes.length, (index) {
                Statistic? homeStats;
                Statistic? awayStats;

                try {
                  homeStats = teamStatistics[0]
                      .statistics
                      .where(
                        (element) =>
                            element.type.toUpperCase().replaceAll(' ', '') ==
                            Strings.statisticsTypes[index].toUpperCase().replaceAll(' ', ''),
                      )
                      .first;
                } catch (_) {}

                try {
                  awayStats = teamStatistics[1]
                      .statistics
                      .where(
                        (element) =>
                            element.type.toUpperCase().replaceAll(' ', '') ==
                            Strings.statisticsTypes[index].toUpperCase().replaceAll(' ', ''),
                      )
                      .first;
                } catch (_) {}

                return CompareWidget(
                  title: Strings.statisticsTypes[index],
                  homeValue: '${homeStats?.value}',
                  awayValue: '${awayStats?.value}',
                  homeBaseCount:
                      homeStats?.value is num ? homeStats?.value + awayStats?.value : 100,
                  awayBaseCount:
                      homeStats?.value is num ? homeStats?.value + awayStats?.value : 100,
                );
              }),
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
            context.read<FixtureStatisticsCubit>().getFixtureStatistics(
                  fixtureId: fixtureId,
                );
          },
        );
      },
    );
  }
}
