import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../_utils/utils.dart';
import '../../constants/assets.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../constants/strings.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/players_statistics/player_statistics.dart';
import '../../features/football_api/models/players_statistics/players_statistic.dart';
import 'custom_image.dart';
import 'info_widget.dart';
import 'player_rating.dart';
import 'shadowless_card.dart';
import 'statistics_widget.dart';

class PlayerStatsWidget extends StatefulWidget {
  const PlayerStatsWidget({
    super.key,
    this.playerStatistic,
    required this.teamId,
    required this.playersStatistics,
  });

  final PlayerStatistics? playerStatistic;
  final List<PlayersStatistic> playersStatistics;
  final int? teamId;

  @override
  State<PlayerStatsWidget> createState() => _PlayerStatsWidgetState();
}

class _PlayerStatsWidgetState extends State<PlayerStatsWidget> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  final List<PlayerStatistics?> playerStatistic = [];
  final List<int?> teamsIds = [];
  PlayerStatistics? currentPlayerStatistic;
  late int? teamId;

  @override
  void initState() {
    super.initState();
    currentPlayerStatistic = widget.playerStatistic;
    teamId = widget.teamId;
    for (final teamPlayersStatistics in widget.playersStatistics) {
      for (final i in teamPlayersStatistics.players) {
        playerStatistic.add(i);
        teamsIds.add(teamPlayersStatistics.team.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(DefaultValues.padding / 2),
          child: ShadowlessCard(
            opacity: 1,
            child: Padding(
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.h,
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
                          imageUrl: Utils.playerImage(currentPlayerStatistic?.player.id),
                          placeholder: Assets.playerPlaceholder,
                        ),
                      ),
                      if (currentPlayerStatistic?.statistics[0].games.captain ?? false)
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(DefaultValues.spacing / 8),
                          decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            color: context.colorScheme.surface,
                          ),
                          child: Text(
                            'C',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.surface,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              if (currentPlayerStatistic?.statistics[0].games.number != null)
                                TextSpan(
                                    text:
                                        '${currentPlayerStatistic!.statistics[0].games.number} - '),
                              TextSpan(
                                text: currentPlayerStatistic?.player.name ?? '-',
                              ),
                            ],
                          ),
                        ),
                        if (currentPlayerStatistic?.statistics[0].games.position != null) ...[
                          Gap(DefaultValues.spacing / 4),
                          Text(
                            currentPlayerStatistic!.statistics[0].games.position!.longName,
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (currentPlayerStatistic?.statistics[0].games.rating != null) ...[
                    Gap(DefaultValues.spacing / 2),
                    PlayerRating(
                      rating: currentPlayerStatistic!.statistics[0].games.rating!,
                      style: context.textTheme.bodyMedium,
                      padding: EdgeInsets.symmetric(
                        horizontal: DefaultValues.padding / 2,
                        vertical: DefaultValues.padding / 8,
                      ),
                    ),
                  ],
                  Gap(DefaultValues.spacing / 2),
                  Container(
                    height: 35.h,
                    width: 35.h,
                    clipBehavior: Clip.antiAlias,
                    padding: EdgeInsets.all(DefaultValues.padding / 4),
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.primary,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      color: context.colorScheme.tertiaryContainer,
                    ),
                    child: CustomNetworkImage(
                      imageUrl: Utils.teamLogo(teamId),
                      placeholder: Assets.teamLogoPlaceholder,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            child: (currentPlayerStatistic?.statistics[0].games.minutes == 0)
                ? InfoWidget(
                    text: Strings.noStatistics2,
                    message: Strings.noPlayerNotPlayed,
                    icon: soccer24Icons.empty,
                    color: context.colorScheme.secondaryContainer,
                  )
                : Column(
                    children: [
                      _basicInfo(),
                      _goals(),
                      _shotsAndPasses(),
                      _penalties(),
                      _tacklesDualsDribbles(),
                      _foolsAndCards(),
                    ],
                  ),
          ),
        ),
        SizedBox(
          height: 40.h,
          child: ScrollablePositionedList.separated(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            scrollDirection: Axis.horizontal,
            itemScrollController: itemScrollController,
            scrollOffsetController: scrollOffsetController,
            itemPositionsListener: itemPositionsListener,
            scrollOffsetListener: scrollOffsetListener,
            itemCount: playerStatistic.length,
            initialScrollIndex: playerStatistic.indexOf(currentPlayerStatistic),
            initialAlignment: DefaultValues.spacing / 1.sw,
            separatorBuilder: (_, __) => Gap(DefaultValues.spacing / 2),
            itemBuilder: (context, index) {
              return ChoiceChip(
                selected: playerStatistic[index] == currentPlayerStatistic,
                showCheckmark: false,
                onSelected: (_) {
                  setState(() {
                    currentPlayerStatistic = playerStatistic[index];
                    teamId = teamsIds[index];
                  });
                  itemScrollController.scrollTo(
                    index: index,
                    alignment: DefaultValues.spacing / 1.sw,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                },
                label: Text(playerStatistic[index]!.player.name!),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _basicInfo() {
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: Column(
          children: [
            if (currentPlayerStatistic?.statistics[0].games.minutes != null) ...[
              StatisticWidget(
                text: Strings.minutesPlayed,
                value: '${currentPlayerStatistic!.statistics[0].games.minutes}\'',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].games.number != null) ...[
              StatisticWidget(
                text: Strings.shirtNumber,
                value: '${currentPlayerStatistic!.statistics[0].games.number}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].games.substitute != null) ...[
              StatisticWidget(
                text: Strings.startedGame,
                value: currentPlayerStatistic!.statistics[0].games.substitute
                    ? Strings.no
                    : Strings.yes,
              ),
              Gap(DefaultValues.spacing / 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _goals() {
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: Column(
          children: [
            if (currentPlayerStatistic?.statistics[0].goals.total != null) ...[
              StatisticWidget(
                text: Strings.goals,
                value: '${currentPlayerStatistic!.statistics[0].goals.total}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].goals.saves != null) ...[
              StatisticWidget(
                text: Strings.saves,
                value: '${currentPlayerStatistic!.statistics[0].goals.saves}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].goals.assists != null) ...[
              StatisticWidget(
                text: Strings.assists,
                value: '${currentPlayerStatistic!.statistics[0].goals.assists}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].goals.conceded != null) ...[
              StatisticWidget(
                text: Strings.conceded,
                value: '${currentPlayerStatistic!.statistics[0].goals.conceded}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _shotsAndPasses() {
    final int? totalShots = currentPlayerStatistic?.statistics[0].shots.total;
    final int? shotsOnTarget = currentPlayerStatistic?.statistics[0].shots.on;
    final int? totalPasses = currentPlayerStatistic?.statistics[0].passes.total;
    final String? passesAccuracy = currentPlayerStatistic?.statistics[0].passes.accuracy;
    final int? keyPasses = currentPlayerStatistic?.statistics[0].passes.key;

    String accuracyPercentage = '';

    try {
      if (passesAccuracy != null && totalPasses != null && totalPasses != 0) {
        final double percent = (double.parse(passesAccuracy) / totalPasses) * 100;
        accuracyPercentage = ' (${percent.toStringAsFixed(0)}%)';
      }
    } catch (_) {}

    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: Column(
          children: [
            if (totalShots != null) ...[
              StatisticWidget(
                text: Strings.shots,
                value: '$totalShots (${shotsOnTarget ?? 0})',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (totalPasses != null) ...[
              StatisticWidget(
                text: Strings.totalPasses,
                value: '$totalPasses',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (totalPasses != null) ...[
              StatisticWidget(
                text: Strings.accuratePasses,
                value: '$passesAccuracy$accuracyPercentage',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (keyPasses != null) ...[
              StatisticWidget(
                text: Strings.keyPasses,
                value: '$keyPasses',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _penalties() {
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: Column(
          children: [
            if (currentPlayerStatistic?.statistics[0].penalty.won != null) ...[
              StatisticWidget(
                text: Strings.wonPenalties,
                value: '${currentPlayerStatistic!.statistics[0].penalty.won}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].penalty.scored != null) ...[
              StatisticWidget(
                text: Strings.scoredPenalties,
                value: '${currentPlayerStatistic!.statistics[0].penalty.scored}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].penalty.commited != null) ...[
              StatisticWidget(
                text: Strings.committedPenalties,
                value: '${currentPlayerStatistic!.statistics[0].penalty.commited}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].penalty.missed != null) ...[
              StatisticWidget(
                text: Strings.missedPenalties,
                value: '${currentPlayerStatistic!.statistics[0].penalty.missed}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].penalty.saved != null) ...[
              StatisticWidget(
                text: Strings.savedPenalties,
                value: '${currentPlayerStatistic!.statistics[0].penalty.saved}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tacklesDualsDribbles() {
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: Column(
          children: [
            if (currentPlayerStatistic?.statistics[0].duels.total != null) ...[
              StatisticWidget(
                text: Strings.duals,
                value:
                    '${currentPlayerStatistic!.statistics[0].duels.total} (${currentPlayerStatistic!.statistics[0].duels.won})',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].dribbles.attempts != null) ...[
              StatisticWidget(
                text: Strings.dribble,
                value:
                    '${currentPlayerStatistic!.statistics[0].dribbles.attempts} (${currentPlayerStatistic!.statistics[0].dribbles.success})',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].tackles.total != null) ...[
              StatisticWidget(
                text: Strings.tackles,
                value: '${currentPlayerStatistic!.statistics[0].tackles.total}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].tackles.blocks != null) ...[
              StatisticWidget(
                text: Strings.blocks,
                value: '${currentPlayerStatistic!.statistics[0].tackles.blocks}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].tackles.interceptions != null) ...[
              StatisticWidget(
                text: Strings.interceptions,
                value: '${currentPlayerStatistic!.statistics[0].tackles.interceptions}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _foolsAndCards() {
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: Column(
          children: [
            if (currentPlayerStatistic?.statistics[0].offsides != null) ...[
              StatisticWidget(
                text: Strings.offsides,
                value: '${currentPlayerStatistic!.statistics[0].offsides}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].fouls.drawn != null) ...[
              StatisticWidget(
                text: Strings.fouls,
                value: '${currentPlayerStatistic!.statistics[0].fouls.drawn}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].fouls.committed != null) ...[
              StatisticWidget(
                text: Strings.committedFouls,
                value: '${currentPlayerStatistic!.statistics[0].fouls.committed}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].cards.yellow != null) ...[
              StatisticWidget(
                text: Strings.yellowCards,
                value: '${currentPlayerStatistic!.statistics[0].cards.yellow}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
            if (currentPlayerStatistic?.statistics[0].cards.red != null) ...[
              StatisticWidget(
                text: Strings.redCard,
                value: '${currentPlayerStatistic!.statistics[0].cards.red}',
              ),
              Gap(DefaultValues.spacing / 4),
            ],
          ],
        ),
      ),
    );
  }
}

