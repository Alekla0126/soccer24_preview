import '../../features/football_api/models/predictions/prediction_teams.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import '../../constants/constants.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import 'package:gap/gap.dart';
import 'shadowless_card.dart';
import 'compare_widget.dart';
import 'text_divider.dart';
import 'form_blocs.dart';


class LeagueStatsCard extends StatefulWidget {
  const LeagueStatsCard({super.key, required this.stats, required this.leagueName});

  final TeamsStats stats;
  final String leagueName;

  @override
  State<LeagueStatsCard> createState() => _LeagueStatsCardState();
}

class _LeagueStatsCardState extends State<LeagueStatsCard> {
  late int selectedIndex;

  late int homePlayed;
  late int homeWins;
  late int homeDraws;
  late int homeLoses;
  late int awayPlayed;
  late int awayWins;
  late int awayDraws;
  late int awayLoses;

  @override
  void initState() {
    super.initState();
    _setTotalValues();
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Strings.leagueStats,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(DefaultValues.spacing),
                Text(
                  widget.leagueName,
                  style: context.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            child: Column(
              children: [
                //Form
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: FormBlocs(form: widget.stats.home?.leagueStats?.form ?? '')),
                    Expanded(child: FormBlocs(form: widget.stats.away?.leagueStats?.form ?? '')),
                  ],
                ),

                //region Games Played
                Gap(DefaultValues.spacing),
                const TextDivider(text: Strings.gamesPlayed),
                Gap(DefaultValues.spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      onSelected: (selected) {
                        setState(() {
                          _setTotalValues();
                        });
                      },
                      selected: selectedIndex == 0,
                      label: const Text(Strings.total),
                    ),
                    ChoiceChip(
                      onSelected: (selected) {
                        setState(() {
                          _selHomeValues();
                        });
                      },
                      selected: selectedIndex == 1,
                      label: const Text(Strings.home),
                    ),
                    ChoiceChip(
                      onSelected: (selected) {
                        setState(() {
                          _setAwayValues();
                        });
                      },
                      selected: selectedIndex == 2,
                      label: const Text(Strings.away),
                    ),
                  ],
                ),
                Gap(DefaultValues.spacing / 2),
                CompareWidget(
                  title: Strings.total,
                  homeValue: '$homePlayed',
                  awayValue: '$awayPlayed',
                  homeBaseCount: homePlayed,
                  awayBaseCount: awayPlayed,
                ),
                CompareWidget(
                  title: Strings.wins,
                  homeValue: '$homeWins',
                  awayValue: '$awayWins',
                  homeBaseCount: homePlayed,
                  awayBaseCount: awayPlayed,
                ),
                CompareWidget(
                  title: Strings.draws,
                  homeValue: '$homeDraws',
                  awayValue: '$awayDraws',
                  homeBaseCount: homePlayed,
                  awayBaseCount: awayPlayed,
                ),
                CompareWidget(
                  title: Strings.loses,
                  homeValue: '$homeLoses',
                  awayValue: '$awayLoses',
                  homeBaseCount: homePlayed,
                  awayBaseCount: awayPlayed,
                ),
                //endregion

                //region Goals By Minutes
                Gap(DefaultValues.spacing),
                const TextDivider(text: Strings.goalsByMinutes),
                Gap(DefaultValues.spacing / 2),
                Table(
                  // columnWidths: const {
                  //   0: FlexColumnWidth(4),
                  //   1: FlexColumnWidth(4),
                  //   2: FlexColumnWidth(3),
                  //   3: FlexColumnWidth(4),
                  //   4: FlexColumnWidth(4),
                  // },
                  border: TableBorder(
                    // borderRadius: BorderRadius.circular(kRadius),
                    top: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    right: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    left: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    bottom: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    horizontalInside:
                        BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    verticalInside:
                        BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        // shape: const StadiumBorder(),
                        color: context.colorScheme.tertiaryContainer,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.against,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.for0,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.minutes,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.for0,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.against,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...List<TableRow>.generate(
                      Constants.matchMinutesValues.length,
                      (index) {
                        return TableRow(
                          children: [
                            _tableRowItem(
                              context: context,
                              total: widget.stats.home?.leagueStats?.goals?.goalsAgainst
                                      ?.minute?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.home?.leagueStats?.goals?.goalsAgainst
                                      ?.minute?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                            _tableRowItem(
                              context: context,
                              total: widget.stats.home?.leagueStats?.goals?.goalsFor
                                      ?.minute?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.home?.leagueStats?.goals?.goalsFor
                                      ?.minute?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                            Padding(
                              padding: EdgeInsets.all(DefaultValues.padding / 4),
                              child: Text(
                                Constants.matchMinutesValues[index],
                                style: context.textTheme.labelSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _tableRowItem(
                              context: context,
                              total: widget.stats.away?.leagueStats?.goals?.goalsFor
                                      ?.minute?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.away?.leagueStats?.goals?.goalsFor
                                      ?.minute?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                            _tableRowItem(
                              context: context,
                              total: widget.stats.away?.leagueStats?.goals?.goalsAgainst
                                      ?.minute?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.away?.leagueStats?.goals?.goalsAgainst
                                      ?.minute?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                          ],
                        );
                      },
                    ),
                    TableRow(
                      children: [
                        _tableRowItem(
                          context: context,
                          total:
                              widget.stats.home?.leagueStats?.goals?.goalsAgainst?.total?.total ??
                                  0,
                          percentage:
                              widget.stats.home?.leagueStats?.goals?.goalsAgainst?.average?.total ??
                                  '-',
                        ),
                        _tableRowItem(
                          context: context,
                          total: widget.stats.home?.leagueStats?.goals?.goalsFor?.total?.total ?? 0,
                          percentage:
                              widget.stats.home?.leagueStats?.goals?.goalsFor?.average?.total ??
                                  '-',
                        ),
                        Padding(
                          padding: EdgeInsets.all(DefaultValues.padding / 4),
                          child: Text(
                            Strings.total,
                            style:
                                context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _tableRowItem(
                          context: context,
                          total: widget.stats.away?.leagueStats?.goals?.goalsFor?.total?.total ?? 0,
                          percentage:
                              widget.stats.away?.leagueStats?.goals?.goalsFor?.average?.total ??
                                  '-',
                        ),
                        _tableRowItem(
                          context: context,
                          total:
                              widget.stats.away?.leagueStats?.goals?.goalsAgainst?.total?.total ??
                                  0,
                          percentage:
                              widget.stats.away?.leagueStats?.goals?.goalsAgainst?.average?.total ??
                                  '-',
                        ),
                      ],
                    ),
                  ],
                ),
                //endregion

                //region Cards By Minutes
                Gap(DefaultValues.spacing),
                const TextDivider(text: Strings.cardsByMinutes),
                Gap(DefaultValues.spacing / 2),
                Table(
                  // columnWidths: const {
                  //   0: FlexColumnWidth(3),
                  //   1: FlexColumnWidth(3),
                  //   2: FlexColumnWidth(4),
                  //   3: FlexColumnWidth(3),
                  //   4: FlexColumnWidth(3),
                  // },
                  border: TableBorder(
                    top: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    right: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    left: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    bottom: BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    horizontalInside:
                        BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                    verticalInside:
                        BorderSide(color: context.colorScheme.tertiaryContainer, width: 1),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: context.colorScheme.tertiaryContainer,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.red,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.yellow,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.minutes,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.yellow,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                          child: Text(
                            Strings.red,
                            style: context.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...List<TableRow>.generate(
                      Constants.matchMinutesValues.length,
                      (index) {
                        return TableRow(
                          children: [
                            _tableRowItem(
                              context: context,
                              total: widget.stats.home?.leagueStats?.cards
                                      ?.red?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.home?.leagueStats?.cards
                                      ?.red?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                            _tableRowItem(
                              context: context,
                              total: widget.stats.home?.leagueStats?.cards
                                      ?.yellow?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.home?.leagueStats?.cards
                                      ?.yellow?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                            Padding(
                              padding: EdgeInsets.all(DefaultValues.padding / 4),
                              child: Text(
                                Constants.matchMinutesValues[index],
                                style: context.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _tableRowItem(
                              context: context,
                              total: widget.stats.away?.leagueStats?.cards
                                      ?.yellow?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.away?.leagueStats?.cards
                                      ?.yellow?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                            _tableRowItem(
                              context: context,
                              total: widget.stats.away?.leagueStats?.cards
                                      ?.red?[Constants.matchMinutesValues[index]]?.total ??
                                  0,
                              percentage: widget.stats.away?.leagueStats?.cards
                                      ?.red?[Constants.matchMinutesValues[index]]?.percentage ??
                                  '0%',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                //endregion
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _tableRowItem({
    required BuildContext context,
    required int total,
    required String percentage,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DefaultValues.padding / 2,
        vertical: DefaultValues.padding / 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$total',
            style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '${percentage.split('.').first.replaceAll('%', '')}%',
            style: context.textTheme.labelSmall?.copyWith(fontSize: 8.r),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _setAwayValues() {
    selectedIndex = 2;
    homePlayed = widget.stats.home?.leagueStats?.fixtures?.played?.away ?? 0;
    homeWins = widget.stats.home?.leagueStats?.fixtures?.wins?.away ?? 0;
    homeDraws = widget.stats.home?.leagueStats?.fixtures?.draws?.away ?? 0;
    homeLoses = widget.stats.home?.leagueStats?.fixtures?.loses?.away ?? 0;
    awayPlayed = widget.stats.away?.leagueStats?.fixtures?.played?.away ?? 0;
    awayWins = widget.stats.away?.leagueStats?.fixtures?.wins?.away ?? 0;
    awayDraws = widget.stats.away?.leagueStats?.fixtures?.draws?.away ?? 0;
    awayLoses = widget.stats.away?.leagueStats?.fixtures?.loses?.away ?? 0;
  }

  void _selHomeValues() {
    selectedIndex = 1;
    homePlayed = widget.stats.home?.leagueStats?.fixtures?.played?.home ?? 0;
    homeWins = widget.stats.home?.leagueStats?.fixtures?.wins?.home ?? 0;
    homeDraws = widget.stats.home?.leagueStats?.fixtures?.draws?.home ?? 0;
    homeLoses = widget.stats.home?.leagueStats?.fixtures?.loses?.home ?? 0;
    awayPlayed = widget.stats.away?.leagueStats?.fixtures?.played?.home ?? 0;
    awayWins = widget.stats.away?.leagueStats?.fixtures?.wins?.home ?? 0;
    awayDraws = widget.stats.away?.leagueStats?.fixtures?.draws?.home ?? 0;
    awayLoses = widget.stats.away?.leagueStats?.fixtures?.loses?.home ?? 0;
  }

  void _setTotalValues() {
    selectedIndex = 0;
    homePlayed = widget.stats.home?.leagueStats?.fixtures?.played?.total ?? 0;
    homeWins = widget.stats.home?.leagueStats?.fixtures?.wins?.total ?? 0;
    homeDraws = widget.stats.home?.leagueStats?.fixtures?.draws?.total ?? 0;
    homeLoses = widget.stats.home?.leagueStats?.fixtures?.loses?.total ?? 0;
    awayPlayed = widget.stats.away?.leagueStats?.fixtures?.played?.total ?? 0;
    awayWins = widget.stats.away?.leagueStats?.fixtures?.wins?.total ?? 0;
    awayDraws = widget.stats.away?.leagueStats?.fixtures?.draws?.total ?? 0;
    awayLoses = widget.stats.away?.leagueStats?.fixtures?.loses?.total ?? 0;
  }
}