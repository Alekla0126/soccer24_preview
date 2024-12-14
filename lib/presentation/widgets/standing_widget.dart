import '../../features/football_api/models/standings/all_stats.dart';
import '../../features/football_api/models/standings/standing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../extensions/enums.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'standing_text.dart';
import 'custom_image.dart';
import 'form_blocs.dart';




class StandingWidget extends StatelessWidget {
  const StandingWidget({
    super.key,
    this.standing,
    this.statsType,
    this.tableType,
    this.isHeader = false,
    this.rankColor,
  });

  final Standing? standing;
  final StandingStatsType? statsType;
  final StandingTableType? tableType;
  final bool isHeader;
  final Color? rankColor;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Stats? stats;
        Icon? statusIcon;

        if (!isHeader) {
          switch (statsType!) {
            case StandingStatsType.all:
              stats = standing!.all;
              break;
            case StandingStatsType.home:
              stats = standing!.home;
              break;
            case StandingStatsType.away:
              stats = standing!.away;
              break;
          }
          if (standing?.status?.contains('up') ?? false) {
            statusIcon = Icon(
              soccer24Icons.arrowUp,
              color: AppColors.greenColor,
              size: 10.r,
            );
          } else if (standing?.status?.contains('down') ?? false) {
            statusIcon = Icon(
              soccer24Icons.arrowDown,
              color: AppColors.redColor,
              size: 10.r,
            );
          }
        }

        return Row(
          children: [
            SizedBox(
              width: 25.h,
              child: isHeader
                  ? Text(
                      '#',
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 25.h,
                          width: 25.h,
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            color: rankColor,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: context.colorScheme.primary,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ),
                          ),
                          child: Text(
                            '${standing!.rank}',
                            style: context.textTheme.labelMedium,
                          ),
                        ),
                        if (statusIcon != null)
                          Positioned(
                            top: -5.r,
                            right: -5.r,
                            child: statusIcon,
                          ),
                      ],
                    ),
            ),
            Gap(DefaultValues.spacing / 2),
            Expanded(
              child: isHeader
                  ? Text(
                      Strings.team,
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    )
                  : Row(
                      children: [
                        if (tableType != StandingTableType.full) ...[
                          Container(
                            height: 25.h,
                            width: 25.h,
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
                              imageUrl: Utils.teamLogo(standing!.team.id),
                              placeholder: Assets.teamLogoPlaceholder,
                            ),
                          ),
                          Gap(DefaultValues.spacing / 2),
                        ],
                        Flexible(
                          child: Text(
                            standing!.team.name,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isHeader ? null : context.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
            if (tableType != StandingTableType.form) ...[
              Gap(DefaultValues.spacing / 2),
              SizedBox(
                width: 25.w,
                child: StandingText(
                  title: 'P',
                  text: '${stats?.played ?? '-'}',
                  isHeader: isHeader,
                ),
              ),
              Gap(DefaultValues.spacing / 8),
              SizedBox(
                width: 25.w,
                child: StandingText(
                  title: 'W',
                  text: '${stats?.win ?? '-'}',
                  isHeader: isHeader,
                ),
              ),
              Gap(DefaultValues.spacing / 8),
              SizedBox(
                width: 25.w,
                child: StandingText(
                  title: 'D',
                  text: '${stats?.draw ?? '-'}',
                  isHeader: isHeader,
                ),
              ),
              Gap(DefaultValues.spacing / 8),
              SizedBox(
                width: 25.w,
                child: StandingText(
                  title: 'L',
                  text: '${stats?.lose ?? '-'}',
                  isHeader: isHeader,
                ),
              ),
              Gap(DefaultValues.spacing / 8),
              if (tableType == StandingTableType.full) ...[
                SizedBox(
                  width: 25.w,
                  child: StandingText(
                    title: 'GF',
                    text: '${stats?.goals.goalsFor ?? '-'}',
                    isHeader: isHeader,
                  ),
                ),
                Gap(DefaultValues.spacing / 8),
                SizedBox(
                  width: 25.w,
                  child: StandingText(
                    title: 'GA',
                    text: '${stats?.goals.against ?? '-'}',
                    isHeader: isHeader,
                  ),
                ),
                Gap(DefaultValues.spacing / 8),
                SizedBox(
                  width: 25.w,
                  child: StandingText(
                    title: 'Diff',
                    text: '${standing?.goalsDiff ?? '-'}',
                    isHeader: isHeader,
                  ),
                ),
                Gap(DefaultValues.spacing / 8),
              ],
              SizedBox(
                width: 25.w,
                child: StandingText(
                  title: Strings.pts,
                  text: '${standing?.points ?? '-'}',
                  boldText: true,
                  isHeader: isHeader,
                ),
              ),
            ],
            if (tableType == StandingTableType.form)
              Expanded(
                child: isHeader
                    ? Text(
                        Strings.form,
                        style: context.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      )
                    : FormBlocs(
                        form: standing?.form ?? '',
                        showTitle: false,
                        limit: standing?.form?.length,
                        textStyle: context.textTheme.bodySmall,
                      ),
              ),
          ],
        );
      },
    );
  }
}
