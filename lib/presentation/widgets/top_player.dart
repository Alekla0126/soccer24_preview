import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../_utils/utils.dart';
import '../../constants/assets.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/players_statistics/top_players/player_info.dart';
import 'custom_image.dart';
import 'shadowless_card.dart';

class TopPlayer extends StatelessWidget {
  const TopPlayer({
    super.key,
    required this.playerInfo,
    required this.statsWidget,
    required this.teamId,
  });

  final int teamId;
  final PlayerInfo playerInfo;
  final Widget statsWidget;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DefaultValues.padding / 2,
          vertical: DefaultValues.padding / 4,
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 35.h,
                  width: 35.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: context.colorScheme.primary,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: Utils.playerImage(playerInfo.id),
                    placeholder: Assets.playerPlaceholder,
                  ),
                ),
                Positioned(
                  right: -DefaultValues.spacing / 2,
                  child: Container(
                    height: 15.h,
                    width: 15.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: context.colorScheme.secondaryContainer,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.primary,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: Utils.teamLogo(teamId),
                      placeholder: Assets.teamLogoPlaceholder,
                    ),
                  ),
                ),
              ],
            ),
            Gap(DefaultValues.padding),
            Expanded(
              child: Text(
                playerInfo.name,
                style: context.textTheme.bodyLarge,
              ),
            ),
            Gap(DefaultValues.padding),
            statsWidget,
          ],
        ),
      ),
    );
  }
}
