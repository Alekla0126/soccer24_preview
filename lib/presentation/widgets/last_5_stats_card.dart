import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../constants/colors.dart';
import '../../constants/default_values.dart';
import '../../constants/strings.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/predictions/prediction_teams.dart';
import 'shadowless_card.dart';

class Last5StatsCard extends StatefulWidget {
  const Last5StatsCard({super.key, required this.stats});

  final TeamsStats stats;

  @override
  State<Last5StatsCard> createState() => _Last5StatsCardState();
}

class _Last5StatsCardState extends State<Last5StatsCard> {
  late final Map<String, dynamic> data;

  late double homeStrength;
  late double homeAttacking;
  late double homeDefensive;
  late double homeGoalsFor;
  late double homeGoalsAgainst;
  late double awayStrength;
  late double awayAttacking;
  late double awayDefensive;
  late double awayGoalsFor;
  late double awayGoalsAgainst;

  late bool _canShowStats;

  @override
  void initState() {
    super.initState();
    homeStrength = _getValue(widget.stats.home?.last5Stats?.form);
    homeAttacking = _getValue(widget.stats.home?.last5Stats?.att);
    homeDefensive = _getValue(widget.stats.home?.last5Stats?.def);
    homeGoalsFor = _calculatePercentage(
      widget.stats.home?.last5Stats?.goals?.goalsFor?.total ?? 0,
      widget.stats.away?.last5Stats?.goals?.goalsFor?.total ?? 0,
    );
    homeGoalsAgainst = _calculatePercentage(
      widget.stats.home?.last5Stats?.goals?.against?.total ?? 0,
      widget.stats.away?.last5Stats?.goals?.against?.total ?? 0,
    );

    awayStrength = _getValue(widget.stats.away?.last5Stats?.form);
    awayAttacking = _getValue(widget.stats.away?.last5Stats?.att);
    awayDefensive = _getValue(widget.stats.away?.last5Stats?.def);
    awayGoalsFor = _calculatePercentage(
      widget.stats.home?.last5Stats?.goals?.goalsFor?.total ?? 0,
      widget.stats.away?.last5Stats?.goals?.goalsFor?.total ?? 0,
      false,
    );
    awayGoalsAgainst = _calculatePercentage(
      widget.stats.home?.last5Stats?.goals?.against?.total ?? 0,
      widget.stats.away?.last5Stats?.goals?.against?.total ?? 0,
      false,
    );
    _canShowStats = _showStats();
    if (_canShowStats) {
      data = {
        'titles': [
          Strings.strength,
          Strings.attacking,
          Strings.defensive,
          Strings.goalsFor,
          Strings.goalsAgainst
        ],
        'homeValues': [homeStrength, homeAttacking, homeDefensive, homeGoalsFor, homeGoalsAgainst],
        'awayValues': [awayStrength, awayAttacking, awayDefensive, awayGoalsFor, awayGoalsAgainst],
      };
    }
  }

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
              Strings.lastMatches.replaceAll('##', '5'),
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _canShowStats
              ? Padding(
                  padding: EdgeInsets.all(DefaultValues.padding / 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(DefaultValues.padding / 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
                                border: Border.all(color: AppColors.redColor, width: 2),
                                color: AppColors.redColor.withOpacity(.5),
                              ),
                              child: Text(
                                widget.stats.home?.name ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Gap(DefaultValues.spacing / 2),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(DefaultValues.padding / 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
                                border: Border.all(color: AppColors.greenColor, width: 2),
                                color: AppColors.greenColor.withOpacity(.5),
                              ),
                              child: Text(
                                widget.stats.away?.name ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(DefaultValues.spacing / 2),
                      AspectRatio(
                        aspectRatio: 1,
                        child: RadarChart(
                          RadarChartData(
                            titlePositionPercentageOffset: 0.1,
                            tickCount: 10,
                            radarBackgroundColor: AppColors.transparent,
                            borderData: FlBorderData(show: false),
                            radarBorderData: const BorderSide(width: 1),
                            tickBorderData: const BorderSide(width: .5),
                            gridBorderData: const BorderSide(width: 1),
                            titleTextStyle: context.textTheme.labelMedium,
                            ticksTextStyle: context.textTheme.labelSmall,
                            radarShape: RadarShape.polygon,
                            getTitle: (index, angle) {
                              return RadarChartTitle(text: data['titles'][index], angle: angle);
                            },
                            dataSets: _dataSets,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(DefaultValues.padding / 2),
                  child: const Text(Strings.notAvailableForThisMatch),
                ),
        ],
      ),
    );
  }

  List<RadarDataSet> get _dataSets {
    return [
      RadarDataSet(
        fillColor: AppColors.redColor.withOpacity(0.5),
        borderColor: AppColors.redColor,
        dataEntries: [
          RadarEntry(
            value: data['homeValues'][0],
          ),
          RadarEntry(
            value: data['homeValues'][1],
          ),
          RadarEntry(
            value: data['homeValues'][2],
          ),
          RadarEntry(
            value: data['homeValues'][3],
          ),
          RadarEntry(
            value: data['homeValues'][4],
          ),
        ],
      ),
      RadarDataSet(
        fillColor: AppColors.greenColor.withOpacity(0.5),
        borderColor: AppColors.greenColor,
        dataEntries: [
          RadarEntry(
            value: data['awayValues'][0],
          ),
          RadarEntry(
            value: data['awayValues'][1],
          ),
          RadarEntry(
            value: data['awayValues'][2],
          ),
          RadarEntry(
            value: data['awayValues'][3],
          ),
          RadarEntry(
            value: data['awayValues'][4],
          ),
        ],
      ),
      //Using this to insure min is always 0 and max is always 100
      //This is a turnaround
      RadarDataSet(
        fillColor: AppColors.transparent,
        borderColor: AppColors.transparent,
        dataEntries: const [
          RadarEntry(
            value: 100,
          ),
          RadarEntry(
            value: 100,
          ),
          RadarEntry(
            value: 100,
          ),
          RadarEntry(
            value: 100,
          ),
          RadarEntry(
            value: 0,
          ),
        ],
      ),
    ];
  }

  double _getValue(String? stringValue) {
    double value;
    try {
      value = double.parse(stringValue?.replaceAll('%', '') ?? '');
    } catch (_) {
      value = 0;
    }

    return value;
  }

  double _calculatePercentage(int homeValue, int awayValue, [bool calculateForHome = true]) {
    if (homeValue + awayValue == 0) return 0;
    return calculateForHome
        ? (homeValue / (homeValue + awayValue)) * 100
        : (awayValue / (homeValue + awayValue)) * 100;
  }

  bool _showStats() {
    return !(homeStrength == 0 &&
        homeAttacking == 0 &&
        homeDefensive == 0 &&
        homeGoalsFor == 0 &&
        homeGoalsAgainst == 0 &&
        awayStrength == 0 &&
        awayAttacking == 0 &&
        awayDefensive == 0 &&
        awayGoalsFor == 0 &&
        awayGoalsAgainst == 0);
  }
}
