import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../_utils/utils.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/lineups/fixture_lineup.dart';
import 'custom_image.dart';
import 'shadowless_card.dart';

class CoachWidget extends StatelessWidget {
  const CoachWidget({super.key, required this.lineup, this.isHomeTeam = true});

  final FixtureLineup lineup;
  final bool isHomeTeam;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        width: 40.w,
        height: 40.w,
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: CustomNetworkImage(
          imageUrl: Utils.coachImage(lineup.coach?.id),
          placeholder: Assets.playerPlaceholder,
        ),
      ),
      Gap(DefaultValues.spacing / 2),
      Expanded(
        child: Column(
          crossAxisAlignment: isHomeTeam ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              lineup.coach?.name ?? '-',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lineup.team?.name ?? '-',
              style: context.textTheme.labelMedium,
            ),
          ],
        ),
      ),
      if (lineup.formation != null) ...[
        Gap(DefaultValues.spacing / 2),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(DefaultValues.spacing / 4),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            color: AppColors.blackColor,
          ),
          child: Text(
            lineup.formation!,
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ];
    if (!isHomeTeam) {
      children = children.reversed.toList(growable: false);
    }
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.spacing / 2),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
