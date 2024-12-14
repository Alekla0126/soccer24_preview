import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_cubit.dart';
import '../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_state.dart';
import '../../features/football_api/models/players_statistics/player_statistics.dart';
import '../../features/football_api/models/players_statistics/players_statistic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/ads/applovin/applovin_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import 'player_stats_widget.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'player_rating.dart';
import 'custom_image.dart';


class StartingPlayerWidget extends StatelessWidget {
  const StartingPlayerWidget({
    super.key,
    required this.widthFactor,
    required this.heightFactor,
    required this.playerId,
    required this.playerNumber,
    required this.playerName,
    required this.playerStatistic,
    required this.isSubs,
    required this.teamId,
  });

  final int widthFactor;
  final int heightFactor;
  final int? playerId;
  final int? playerNumber;
  final String? playerName;
  final PlayerStatistics? playerStatistic;
  final bool isSubs;
  final int? teamId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.read<ApplovinManager>().showInterstitialAd();
        final List<PlayersStatistic> playersStatistics =
            (context.read<FixtureLineupsCubit>().state as FixtureLineupsLoadedState)
                .playersStatistics;
        if (playersStatistics.isEmpty) return;
        showBottomSheet(
          context: context,
          builder: (context) {
            return PlayerStatsWidget(
              playerStatistic: playerStatistic,
              teamId: teamId,
              playersStatistics: playersStatistics,
            );
          },
        );
      },
      child: SizedBox(
        width: 1.sw / widthFactor,
        height: 1.sw / heightFactor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: 1.sw / (heightFactor * 2),
                    height: 1.sw / (heightFactor * 2),
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: Utils.playerImage(playerId),
                      placeholder: Assets.playerPlaceholder,
                    ),
                  ),
                  if (playerStatistic?.statistics[0].games.rating != null)
                    Positioned(
                      top: 0,
                      left: -DefaultValues.spacing,
                      child: PlayerRating(rating: playerStatistic!.statistics[0].games.rating!),
                    ),
                  if (playerStatistic?.statistics[0].games.captain ?? false)
                    Positioned(
                      top: -DefaultValues.spacing / 2,
                      right: 0,
                      left: 0,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(DefaultValues.spacing / 8),
                        decoration: ShapeDecoration(
                          shape: const CircleBorder(),
                          color: context.colorScheme.onSurface,
                        ),
                        child: Text(
                          'C',
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 9.r,
                            color: context.colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  if (isSubs)
                    Positioned(
                      right: -DefaultValues.spacing / 2,
                      top: 0,
                      child: Image.asset(
                        Assets.substituteOutIconPath,
                        height: 20.h,
                        width: 10.h,
                      ),
                    ),
                  if ((playerStatistic?.statistics[0].goals.total ?? 0) > 0)
                    Positioned(
                      right: -DefaultValues.spacing / 2,
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
                              right: -5.h,
                              child: Container(
                                padding: EdgeInsets.all(DefaultValues.spacing / 8),
                                decoration: ShapeDecoration(
                                    shape: const CircleBorder(),
                                    color: context.colorScheme.onSurface),
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
                  Positioned(
                    bottom: -DefaultValues.spacing / 4,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(DefaultValues.spacing / 8),
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: AppColors.blackColor,
                      ),
                      child: Text(
                        '${playerNumber ?? ''}',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 8.r,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(DefaultValues.spacing / 4),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: DefaultValues.spacing / 8,
                  horizontal: DefaultValues.spacing / 4,
                ),
                decoration: const ShapeDecoration(
                  shape: StadiumBorder(),
                  color: AppColors.blackColor,
                ),
                child: Text(
                  Utils.abbreviateName(playerName),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.whiteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}