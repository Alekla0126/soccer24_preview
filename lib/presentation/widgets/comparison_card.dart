import '../../features/football_api/models/predictions/comparison.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import 'shadowless_card.dart';
import 'compare_widget.dart';


class ComparisonCard extends StatelessWidget {
  const ComparisonCard({super.key, required this.comparison});

  final Comparison comparison;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            color: context.colorScheme.secondaryContainer,
            child: Text(
              Strings.compare,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              CompareWidget(
                title: Strings.strength,
                homeValue: comparison.form!.home!,
                awayValue: comparison.form!.away!,
              ),
              CompareWidget(
                title: Strings.attackingPotential,
                homeValue: comparison.att!.home!,
                awayValue: comparison.att!.away!,
              ),
              CompareWidget(
                title: Strings.defensivePotential,
                homeValue: comparison.def!.home!,
                awayValue: comparison.def!.away!,
              ),
              CompareWidget(
                title: Strings.poissonDistribution,
                homeValue: comparison.poissonDistribution!.home!,
                awayValue: comparison.poissonDistribution!.away!,
              ),
              CompareWidget(
                title: Strings.strengthH2H,
                homeValue: comparison.h2H!.home!,
                awayValue: comparison.h2H!.away!,
              ),
              CompareWidget(
                title: Strings.goalsH2H,
                homeValue: comparison.goals!.home!,
                awayValue: comparison.goals!.away!,
              ),
              CompareWidget(
                title: Strings.winsGame,
                homeValue: comparison.total!.home!,
                awayValue: comparison.total!.away!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}