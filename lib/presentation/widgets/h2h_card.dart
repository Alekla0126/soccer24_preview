import 'package:flutter/material.dart';

import '../../constants/default_values.dart';
import '../../constants/strings.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/fixture/fixture_details.dart';
import 'prediction_h2h_fixture_widget.dart';
import 'shadowless_card.dart';

class H2HCard extends StatelessWidget {
  const H2HCard({super.key, required this.headToHead});

  final List<FixtureDetails> headToHead;

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
              Strings.h2h,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: List<Widget>.generate(headToHead.length, (index) {
              return PredictionH2HFixtureWidget(
                fixture: headToHead[index],
                backgroundColor: index.isOdd
                    ? context.colorScheme.tertiaryContainer.withOpacity(.5)
                    : context.colorScheme.tertiaryContainer.withOpacity(.3),
              );
            }),
          ),
        ],
      ),
    );
  }
}
