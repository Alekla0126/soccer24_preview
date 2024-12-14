import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../constants/assets.dart';
import '../../constants/default_values.dart';
import '../../constants/strings.dart';
import '../../extensions/extensions.dart';
import 'custom_image.dart';

class SimplifiedFixtureWidget extends StatelessWidget {
  const SimplifiedFixtureWidget({
    super.key,
    required this.homeTeamName,
    this.homeTeamLogo,
    required this.awayTeamName,
    this.awayTeamLogo,
    this.status,
  });

  final String homeTeamName;
  final String? homeTeamLogo;
  final String awayTeamName;
  final String? awayTeamLogo;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final bool showLogos = awayTeamLogo != null && homeTeamLogo != null;
    return Row(
      children: [
        Expanded(
          child: Text(
            homeTeamName,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showLogos) ...[
          Gap(DefaultValues.spacing / 2),
          Container(
            padding: EdgeInsets.all(DefaultValues.padding / 4),
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
              imageUrl: homeTeamLogo,
              placeholder: Assets.teamLogoPlaceholder,
              fit: BoxFit.scaleDown,
              height: 15.h,
              width: 15.h,
            ),
          ),
          Gap(DefaultValues.spacing / 2),
          Container(
            padding: EdgeInsets.all(DefaultValues.padding / 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
              color: context.colorScheme.secondaryContainer,
            ),
            child: Text(
              '$status',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
              ),
              // textAlign: TextAlign.center,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToLastDescent: false,
                applyHeightToFirstAscent: false,
              ),
            ),
          ),
          Gap(DefaultValues.spacing / 2),
          Container(
            padding: EdgeInsets.all(DefaultValues.padding / 4),
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
              imageUrl: awayTeamLogo,
              placeholder: Assets.teamLogoPlaceholder,
              fit: BoxFit.scaleDown,
              height: 15.h,
              width: 15.h,
            ),
          ),
          Gap(DefaultValues.spacing / 2),
        ],
        if (!showLogos)
          Container(
            margin: EdgeInsets.symmetric(horizontal: DefaultValues.padding / 2),
            padding: EdgeInsets.all(DefaultValues.padding / 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
              color: context.colorScheme.secondaryContainer,
            ),
            child: Text(
              Strings.vs,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
              ),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToLastDescent: false,
                applyHeightToFirstAscent: false,
              ),
            ),
          ),
        Expanded(
          child: Text(
            awayTeamName,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
