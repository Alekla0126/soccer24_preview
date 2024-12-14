import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../_utils/utils.dart';
import '../../constants/assets.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/fixture/fixture_details.dart';
import 'custom_image.dart';
import 'fixture_card.dart';
import 'shadowless_card.dart';

class H2HFixtureCard extends StatelessWidget {
  const H2HFixtureCard({super.key, required this.fixture});

  final FixtureDetails fixture;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            width: double.infinity,
            color: context.colorScheme.secondaryContainer,
            child: Row(
              children: [
                Container(
                  height: 20.h,
                  width: 20.h,
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: context.colorScheme.primary,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: Utils.leagueLogo(fixture.league.id),
                    placeholder: Assets.leagueLogoPlaceholder,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Gap(DefaultValues.spacing / 2),
                Expanded(
                  child: Text(
                    fixture.league.name,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                Gap(DefaultValues.spacing / 2),
                Text(
                  Utils.formatDateTime(
                    DateTime.fromMillisecondsSinceEpoch(fixture.fixture.timestamp * 1000),
                  ),
                  style: context.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          FixtureCard(fixture: fixture),
        ],
      ),
    );
  }
}
