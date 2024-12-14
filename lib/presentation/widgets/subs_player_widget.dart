import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_cubit.dart';
import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_state.dart';
import '../../features/football_api/models/players_statistics/player_statistics.dart';
import '../../features/football_api/models/players_statistics/players_statistic.dart';
import '../../features/football_api/models/lineups/start_xi_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import 'player_stats_widget.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'shadowless_card.dart';
import 'player_rating.dart';
import 'custom_image.dart';


class SubsPlayerWidget extends StatelessWidget {
  const SubsPlayerWidget({
    super.key,
    required this.player,
    required this.playerStatistic,
    this.reverse = false,
    required this.teamId,
  });

  final StartXiPlayer? player;
  final PlayerStatistics? playerStatistic;
  final bool reverse;
  final int? teamId;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40.h,
            height: 40.h,
            clipBehavior: Clip.antiAlias,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
            ),
            child: CustomNetworkImage(
              imageUrl: Utils.playerImage(player?.id),
              placeholder: Assets.playerPlaceholder,
            ),
          ),
          if (playerStatistic?.statistics[0].games.rating != null)
            Positioned(
              top: -DefaultValues.spacing / 4,
              right: reverse ? null : -DefaultValues.spacing / 2,
              left: !reverse ? null : -DefaultValues.spacing / 2,
              child: PlayerRating(rating: playerStatistic!.statistics[0].games.rating!),
            ),
          if ((playerStatistic?.statistics[0].goals.total ?? 0) > 0)
            Positioned(
              right: !reverse ? null : 0,
              left: reverse ? null : 0,
              bottom: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    Assets.goalIconPath,
                    height: 15.h,
                    width: 15.h,
                    color: AppColors.blackColor,
                  ),
                  if ((playerStatistic?.statistics[0].goals.total ?? 0) > 1)
                    Positioned(
                      top: -5.h,
                      right: !reverse ? null : -3.h,
                      left: reverse ? null : -3.h,
                      child: Container(
                        padding: EdgeInsets.all(DefaultValues.spacing / 8),
                        decoration: ShapeDecoration(
                            shape: const CircleBorder(), color: context.colorScheme.onSurface),
                        child: Text(
                          '${playerStatistic?.statistics[0].goals.total}',
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 7.r,
                            color: context.colorScheme.surface,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToLastDescent: false,
                            applyHeightToFirstAscent: false,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (player?.number != null)
            Positioned(
              bottom: 0,
              left: reverse ? 0 : null,
              right: !reverse ? 0 : null,
              child: CircleAvatar(
                radius: DefaultValues.radius / 2.5,
                backgroundColor: context.colorScheme.onSurface.withOpacity(0.7),
                child: Text(
                  player!.number!.toString(),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.surface,
                    fontSize: 9.r,
                  ),
                ),
              ),
            ),
          if ((playerStatistic?.statistics[0].games.minutes ?? 0) > 0)
            Positioned(
              left: !reverse ? 0 : null,
              right: reverse ? 0 : null,
              top: -DefaultValues.spacing / 4,
              child: Image.asset(
                Assets.substituteInIconPath,
                height: 20.h,
                width: 10.h,
              ),
            ),
        ],
      ),
      Gap(DefaultValues.spacing),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: !reverse ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              player?.name ?? '-',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: !reverse ? TextAlign.start : TextAlign.end,
            ),
            if (player?.pos?.longName != null)
              Text(
                player!.pos!.longName,
                style: context.textTheme.bodySmall,
                textAlign: !reverse ? TextAlign.start : TextAlign.end,
              ),
          ],
        ),
      ),
    ];

    if (reverse) {
      children = children.reversed.toList(growable: false);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final List<PlayersStatistic> playersStatistics =
            (context.read<FixtureLineupsCubit>().state as FixtureLineupsLoadedState)
                .playersStatistics;
        if (playersStatistics.isEmpty) return;
        showBottomSheet(
          context: context,
          builder: (context) {
            return PlayerStatsWidget(
              teamId: teamId,
              playerStatistic: playerStatistic,
              playersStatistics: playersStatistics,
            );
          },
        );
      },
      child: ShadowlessCard(
        opacity: 0,
        clipBehavior: Clip.none,
        child: Row(
          mainAxisAlignment: !reverse ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}
