import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixture_predictions_cubit/fixture_predictions_cubit.dart';
import '../../../features/football_api/blocs/fixture_predictions_cubit/fixture_predictions_state.dart';
import '../../../features/football_api/models/predictions/predictions_details.dart';
import '../../widgets/bet_tip_card.dart';
import '../../widgets/comparison_card.dart';
import '../../widgets/h2h_card.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/last_5_stats_card.dart';
import '../../widgets/league_stats_card.dart';
import '../../widgets/loading_widget.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({
    super.key,
    required this.fixtureId,
    required this.homeTeamId,
    required this.homeGoals,
    required this.awayGoals,
    required this.isMatchFinished,
  });

  final int fixtureId;
  final int homeTeamId;
  final int? homeGoals;
  final int? awayGoals;
  final bool isMatchFinished;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixturePredictionsCubit, ApiState>(
      builder: (context, predictionState) {
        if (predictionState is LoadingState) {
          return const LoadingWidget();
        }
        if (predictionState is ErrorState) {
          return InfoWidget(
            text: predictionState.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () {
              context.read<FixturePredictionsCubit>().getFixturePredictions(fixtureId: fixtureId);
            },
          );
        }
        if (predictionState is FixturePredictionsLoadedState) {
          final PredictionsDetails? predictions = predictionState.predictions;
          final emptyWidget = InfoWidget(
            text: Strings.noPredictions,
            icon: soccer24Icons.empty,
            color: context.colorScheme.secondaryContainer,
            padding: EdgeInsets.all(DefaultValues.padding),
          );

          if (predictions == null) {
            return emptyWidget;
          }

          if (predictions.predictions == null &&
              predictions.teamsStats == null &&
              predictions.comparison == null &&
              predictions.h2H.isEmpty) {
            return emptyWidget;
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                if (predictions.predictions != null)
                  BetTipCard(
                    predictions: predictions.predictions!,
                    homeTeamId: homeTeamId,
                    homeGoals: homeGoals,
                    awayGoals: awayGoals,
                    isMatchFinished: isMatchFinished,
                  ),
                if (predictions.teamsStats != null) Last5StatsCard(stats: predictions.teamsStats!),
                if (predictions.comparison != null)
                  ComparisonCard(comparison: predictions.comparison!),
                if (predictions.h2H.isNotEmpty) H2HCard(headToHead: predictions.h2H),
                if (predictions.teamsStats != null)
                  LeagueStatsCard(
                    stats: predictions.teamsStats!,
                    leagueName: predictions.league?.name ?? '',
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
            context.read<FixturePredictionsCubit>().getFixturePredictions(fixtureId: fixtureId);
          },
        );
      },
    );
  }
}
