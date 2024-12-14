import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../_utils/utils.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/default_values.dart';
import '../../extensions/enums.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/fixture/fixture_details.dart';
import '../screens/fixture/fixture_screen.dart';
import 'custom_image.dart';

class FixtureCard extends StatelessWidget {
  const FixtureCard({
    super.key,
    required this.fixture,
    this.elevation,
    this.backgroundColor,
    this.showDate = false,
  });

  final FixtureDetails fixture;
  final double? elevation;
  final Color? backgroundColor;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    Widget? elapsedWidget;
    if (fixture.fixture.status.elapsed != null) {
      switch (fixture.fixture.status.short) {
        case FixtureStatusShort.oneH:
        case FixtureStatusShort.twoH:
        case FixtureStatusShort.et:
        case FixtureStatusShort.live:
          elapsedWidget = CircleAvatar(
            radius: DefaultValues.radius / 2,
            child: Text(
              '${fixture.fixture.status.elapsed}\'',
              style: context.textTheme.labelSmall?.copyWith(
                decoration: null,
              ),
            ),
          );
          break;
        default:
          elapsedWidget = null;
          break;
      }
    }

    final Widget fixtureWidget = Card.outlined(
      color: backgroundColor ?? AppColors.transparent,
      elevation: elevation ?? 0,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => context.goTo(FixtureScreen(fixture: fixture)),
            child: Padding(
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Column(
                children: [
                  if (showDate) ...[
                    Text(
                      Utils.formatDateTime(
                        DateTime.fromMillisecondsSinceEpoch(fixture.fixture.timestamp * 1000),
                      ),
                      style: context.textTheme.titleSmall,
                    ),
                    Gap(DefaultValues.spacing / 2),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Home Team
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              padding: EdgeInsets.all(DefaultValues.padding / 4),
                              decoration: ShapeDecoration(
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: context.colorScheme.primary,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                ),
                                color: context.colorScheme.secondaryContainer,
                              ),
                              child: CustomNetworkImage(
                                imageUrl: Utils.teamLogo(fixture.teams.home.id),
                                placeholder: Assets.teamLogoPlaceholder,
                                fit: BoxFit.scaleDown,
                                height: 30.h,
                                width: 30.h,
                              ),
                            ),
                            Gap(DefaultValues.spacing / 4),
                            Text(
                              fixture.teams.home.name,
                              style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: (fixture.teams.home.winner ?? false)
                                      ? FontWeight.bold
                                      : null),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      Gap(DefaultValues.spacing / 2),
                      Expanded(
                        flex: 1,
                        child: _scoreWidget(context),
                      ),
                      Gap(DefaultValues.spacing / 2),
                      //Away Team
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              padding: EdgeInsets.all(DefaultValues.padding / 4),
                              decoration: ShapeDecoration(
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: context.colorScheme.primary,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                ),
                                color: context.colorScheme.secondaryContainer,
                              ),
                              child: CustomNetworkImage(
                                imageUrl: Utils.teamLogo(fixture.teams.away.id),
                                placeholder: Assets.teamLogoPlaceholder,
                                fit: BoxFit.scaleDown,
                                height: 30.h,
                                width: 30.h,
                              ),
                            ),
                            Gap(DefaultValues.spacing / 4),
                            Text(
                              fixture.teams.away.name,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                    (fixture.teams.away.winner ?? false) ? FontWeight.bold : null,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (elapsedWidget != null)
            Positioned(
              left: DefaultValues.spacing / 4,
              top: DefaultValues.spacing / 4,
              child: elapsedWidget,
            ),
        ],
      ),
    );

    return fixtureWidget;
  }

  Widget _scoreWidget(BuildContext context) {
    final Widget statusWidget = Tooltip(
      preferBelow: false,
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
      ),
      message: fixture.fixture.status.long.description,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DefaultValues.padding / 2,
          vertical: DefaultValues.padding / 8,
        ),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: context.colorScheme.secondaryContainer,
        ),
        child: Text(
          fixture.fixture.status.short.asString,
          style: context.textTheme.labelMedium,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
    );

    String? homeGoals;
    String? awayGoals;
    String? time;

    if (fixture.goals.home != null && fixture.goals.away != null) {
      homeGoals = '${fixture.goals.home}';
      awayGoals = '${fixture.goals.away}';
    } else {
      time = Utils.timeFromApiTimestamp(fixture.fixture.timestamp);
    }

    String? penaltyScore;

    if (fixture.score.penalty.home != null && fixture.score.penalty.away != null) {
      penaltyScore = '(${fixture.score.penalty.home} - ${fixture.score.penalty.away})';
    }

    return SizedBox(
      height: 65.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          statusWidget,
          Gap(DefaultValues.spacing / 2),
          if (homeGoals != null || awayGoals != null)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: homeGoals,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: (fixture.teams.home.winner ?? false) ? FontWeight.bold : null,
                    ),
                  ),
                  TextSpan(
                    text: ' - ',
                    style: context.textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: awayGoals,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: (fixture.teams.away.winner ?? false) ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
            ),
          if (time != null)
            Text(
              time,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          if (penaltyScore != null) ...[
            Gap(DefaultValues.spacing / 4),
            Text(penaltyScore, style: context.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
