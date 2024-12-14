import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../_utils/utils.dart';
import '../../constants/assets.dart';
import '../../constants/default_values.dart';
import '../../extensions/enums.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/fixture/fixture_details.dart';
import 'custom_image.dart';

class FixtureDetailsHeader extends StatelessWidget {
  const FixtureDetailsHeader({super.key, required this.fixture});

  final FixtureDetails fixture;

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

    final Widget detailsWidget = Center(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final logoHeight = constraints.maxHeight * .4;
            final leagueHeight = constraints.maxHeight * .3;
            final scoreHeight = constraints.maxHeight - leagueHeight;
            final teamNameHeight = constraints.maxHeight - logoHeight - leagueHeight;
            String leagueName = fixture.league.name;
            if (fixture.league.round != null) {
              leagueName += ', ${fixture.league.round}';
            }

            return Column(
              children: [
                Container(
                  height: leagueHeight,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(DefaultValues.padding / 4),
                  child: Text(
                    leagueName,
                    style: context.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
                            height: logoHeight,
                            width: logoHeight,
                            clipBehavior: Clip.hardEdge,
                            padding: EdgeInsets.all(DefaultValues.padding / 2),
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
                            ),
                          ),
                          Container(
                            height: teamNameHeight,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: DefaultValues.spacing / 2),
                            child: Text(
                              fixture.teams.home.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(DefaultValues.spacing / 2),
                    SizedBox(
                      height: scoreHeight,
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
                            height: logoHeight,
                            width: logoHeight,
                            clipBehavior: Clip.hardEdge,
                            padding: EdgeInsets.all(DefaultValues.padding / 2),
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
                            ),
                          ),
                          Container(
                            height: teamNameHeight,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: DefaultValues.spacing / 2),
                            child: Text(
                              fixture.teams.away.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );

    if (elapsedWidget == null) {
      return detailsWidget;
    }

    return Stack(
      children: [
        detailsWidget,
        Positioned(
          left: DefaultValues.spacing * .75,
          top: DefaultValues.spacing * .75,
          child: elapsedWidget,
        ),
      ],
    );
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
        // height: 25,
        padding: EdgeInsets.symmetric(
          horizontal: DefaultValues.padding / 2,
          vertical: DefaultValues.padding / 8,
        ),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: context.colorScheme.secondaryContainer,
        ),
        child: Text(
          fixture.fixture.status.long.asString,
          style: context.textTheme.bodyMedium,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
    );

    String score;

    if (fixture.goals.home != null && fixture.goals.away != null) {
      score = '${fixture.goals.home} - ${fixture.goals.away}';
    } else {
      score = Utils.timeFromApiTimestamp(fixture.fixture.timestamp);
    }

    String? penaltyScore;

    if (fixture.score.penalty.home != null && fixture.score.penalty.away != null) {
      penaltyScore = '(${fixture.score.penalty.home} - ${fixture.score.penalty.away})';
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        statusWidget,
        Gap(DefaultValues.spacing / 4),
        Text(
          score,
          style: context.textTheme.titleLarge?.copyWith(
            decoration: Utils.isMatchCancelled(fixture.fixture.status.short)
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        if (penaltyScore != null) ...[
          Gap(DefaultValues.spacing / 4),
          Text(penaltyScore, style: context.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
