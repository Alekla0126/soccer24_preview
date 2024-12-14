import '../../features/football_api/models/predictions/predictions.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../constants/colors.dart';
import 'chance_percent_widget.dart';
import 'package:gap/gap.dart';
import 'shadowless_card.dart';
import 'text_divider.dart';


class BetTipCard extends StatelessWidget {
  const BetTipCard({
    super.key,
    required this.predictions,
    required this.homeTeamId,
    required this.homeGoals,
    required this.awayGoals,
    required this.isMatchFinished,
  });

  final Predictions predictions;
  final int homeTeamId;
  final int? homeGoals;
  final int? awayGoals;
  final bool isMatchFinished;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            color: context.colorScheme.secondaryContainer,
            child: _betTips(
              context,
              winnerId: predictions.winner?.id,
              winOrDraw: predictions.winOrDraw,
              homeGoals: homeGoals,
              awayGoals: awayGoals,
              isMatchFinished: isMatchFinished,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            child: Column(
              children: [
                if (predictions.percent != null) ...[
                  const TextDivider(text: Strings.chances),
                  Gap(DefaultValues.spacing / 2),
                  Row(
                    children: [
                      Flexible(
                        child: ChancePercentWidget(
                          title: Strings.home,
                          percent: predictions.percent!.home!,
                        ),
                      ),
                      Gap(DefaultValues.spacing / 2),
                      Flexible(
                        child: ChancePercentWidget(
                          title: Strings.draw,
                          percent: predictions.percent!.draw!,
                        ),
                      ),
                      Gap(DefaultValues.spacing / 2),
                      Flexible(
                        child: ChancePercentWidget(
                          title: Strings.away,
                          percent: predictions.percent!.away!,
                        ),
                      ),
                    ],
                  ),
                  Gap(DefaultValues.spacing),
                ],
                if (predictions.goals != null) ...[
                  const TextDivider(text: Strings.expectedGoals),
                  Gap(DefaultValues.spacing / 2),
                  Row(
                    children: [
                      Flexible(
                        child: ChancePercentWidget(
                          title: Strings.home,
                          percent: predictions.goals!.home,
                        ),
                      ),
                      if (predictions.underOver != null) ...[
                        Gap(DefaultValues.spacing / 2),
                        Flexible(
                          child: ChancePercentWidget(
                            title: Strings.total,
                            percent: predictions.underOver!,
                          ),
                        ),
                      ],
                      Gap(DefaultValues.spacing / 2),
                      Flexible(
                        child: ChancePercentWidget(
                          title: Strings.away,
                          percent: predictions.goals!.away,
                        ),
                      ),
                    ],
                  ),
                  Gap(DefaultValues.spacing),
                ],
                if (predictions.advice != null) ...[
                  const TextDivider(text: Strings.advice),
                  Gap(DefaultValues.spacing / 2),
                  Text(
                    '${predictions.advice}',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (predictions.winner?.name != null) ...[
                    Gap(DefaultValues.spacing / 4),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: context.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '${predictions.winner!.name!} ',
                          ),
                          if (predictions.winner?.comment != null)
                            TextSpan(
                              text: predictions.winner!.comment!,
                            ),
                          if (predictions.winner?.comment == null)
                            const TextSpan(
                              text: Strings.wins,
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _betTips(
    BuildContext context, {
    int? winnerId,
    bool? winOrDraw,
    required int? homeGoals,
    required int? awayGoals,
    required bool isMatchFinished,
  }) {
    bool? successfullyPredicted;
    if (homeGoals == null || awayGoals == null || !isMatchFinished) {
      successfullyPredicted = null;
    } else {
      if ((winOrDraw ?? false) && (homeGoals == awayGoals)) {
        successfullyPredicted = true;
      } else if (winnerId == homeTeamId) {
        successfullyPredicted = homeGoals > awayGoals;
      } else if (winnerId != homeTeamId) {
        successfullyPredicted = homeGoals < awayGoals;
      }
    }

    String tip = '';
    if (winOrDraw ?? false) {
      tip = 'X';
    }
    if (winnerId == homeTeamId) {
      tip = '1$tip';
    } else {
      tip = '${tip}2';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            Strings.betTip,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (winnerId != null) ...[
          if (successfullyPredicted != null) ...[
            Icon(
              successfullyPredicted ? soccer24Icons.correct : soccer24Icons.incorrect,
              color: successfullyPredicted ? AppColors.greenColor : AppColors.redColor,
              size: DefaultValues.radius * .75,
            ),
            Gap(DefaultValues.spacing / 4),
          ],
          Text(
            tip,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}