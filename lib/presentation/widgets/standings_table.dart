import '../../features/football_api/models/standings/standing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../extensions/enums.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'standing_widget.dart';
import 'custom_image.dart';


class StandingsTable extends StatefulWidget {
  const StandingsTable({
    super.key,
    required this.standings,
    required this.leagueId,
    required this.leagueName,
    required this.flag,
    required this.statsType,
    required this.tableType,
  });

  final List<Standing> standings;
  final int leagueId;
  final String leagueName;
  final String? flag;
  final StandingStatsType statsType;
  final StandingTableType tableType;

  @override
  State<StandingsTable> createState() => _StandingsTableState();
}

class _StandingsTableState extends State<StandingsTable> {
  late final String group;
  late final Map<String, Color?> colorsMap;

  @override
  void initState() {
    super.initState();
    group = widget.standings[0].group.replaceAll(widget.leagueName, '').replaceAll(': ', '');
    colorsMap = _buildColorsMap();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Container(
              height: 35.h,
              width: 35.h,
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
                imageUrl: Utils.leagueLogo(widget.leagueId),
                placeholder: Assets.leagueLogoPlaceholder,
              ),
            ),
            Gap(DefaultValues.spacing),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.leagueName,
                    style: context.textTheme.labelLarge,
                  ),
                  if (group.isNotEmpty) ...[
                    Gap(DefaultValues.spacing / 4),
                    Text(
                      group,
                      style: context.textTheme.labelMedium,
                    ),
                  ],
                ],
              ),
            ),
            Gap(DefaultValues.spacing),
            Container(
              height: 35.h,
              width: 35.h,
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
                imageUrl: widget.flag,
                placeholder: Assets.countryLogoPlaceholder,
              ),
            ),
          ],
        ),
        Divider(
          color: context.colorScheme.primary,
          height: DefaultValues.spacing,
        ),
        Column(
          children: List<Widget>.generate(
            widget.standings.length + 1,
            (index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 4),
                child: index == 0
                    ? StandingWidget(
                        isHeader: true,
                        statsType: widget.statsType,
                        tableType: widget.tableType,
                      )
                    : StandingWidget(
                        standing: widget.standings[index - 1],
                        statsType: widget.statsType,
                        tableType: widget.tableType,
                        rankColor: colorsMap['${widget.standings[index - 1].description}'],
                      ),
              );
            },
          ),
        ),
        Divider(color: context.colorScheme.primary),
        ...List<Widget>.generate(
          colorsMap.values.length,
          (index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 4),
              child: Row(
                children: [
                  Container(
                    height: 25.h,
                    width: 25.h,
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: colorsMap.values.toList()[index],
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.primary,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                  ),
                  Gap(DefaultValues.padding / 2),
                  Flexible(child: Text(colorsMap.keys.toList()[index])),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Map<String, Color?> _buildColorsMap() {
    final Map<String, Color?> colors = {};

    final List<String> descriptions = [];

    for (final s in widget.standings) {
      if (s.description == null) continue;
      if (!descriptions.contains(s.description)) {
        descriptions.add(s.description!);
      }
    }

    if (descriptions.length == 1) {
      colors.addAll({descriptions[0]: AppColors.standingsColors[0]});
    } else {
      for (int i = 0; i < descriptions.length; i++) {
        if (i == descriptions.length - 1) {
          colors.addAll({descriptions[i]: AppColors.standingsColors.last});
        } else {
          colors.addAll({descriptions[i]: AppColors.standingsColors[i]});
        }
      }
    }

    return colors;
  }
}