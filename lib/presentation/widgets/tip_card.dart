import '../../features/tips/repositories/tips_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/fixture/fixture_loading_screen.dart';
import '../../features/tips/models/tip_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../constants/assets.dart';
import 'tip_processing_widget.dart';
import '../../_utils/utils.dart';
import 'bet_value_widget.dart';
import 'package:gap/gap.dart';
import 'expandable_text.dart';
import 'shadowless_card.dart';
import 'custom_image.dart';
import 'like_button.dart';


class TipCard extends StatelessWidget {
  const TipCard({super.key, required this.tip, this.preview = false});

  final Tip tip;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
        side: BorderSide(
          color: context.colorScheme.primaryContainer,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            width: double.infinity,
            color: context.colorScheme.secondaryContainer,
            child: Row(
              children: [
                Container(
                  height: 20.h,
                  width: 20.h,
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
                    imageUrl: Utils.leagueLogo(tip.leagueId),
                    placeholder: Assets.leagueLogoPlaceholder,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Gap(DefaultValues.spacing / 2),
                Expanded(
                  child: Text(
                    tip.leagueName,
                    style: context.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(DefaultValues.spacing / 2),
                Text(
                  Utils.formatDateTime(
                    DateTime.fromMillisecondsSinceEpoch(tip.fixtureTimestamp * 1000),
                  ),
                  style: context.textTheme.titleSmall,
                ),
                if (tip.isMine && !preview) ...[
                  Gap(DefaultValues.spacing / 2),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: true,
                        builder: (context) {
                          return TipProcessingWidget(tip: tip);
                        },
                      );
                    },
                    child: Icon(
                      soccer24Icons.edit,
                      size: DefaultValues.radius * 0.75,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: preview
                ? null
                : () => context.goTo(FixtureLoadingScreen(fixtureId: tip.fixtureId)),
            child: Padding(
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40.h,
                    width: 40.h,
                    clipBehavior: Clip.antiAlias,
                    padding: EdgeInsets.all(DefaultValues.padding / 4),
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.primary,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: Utils.teamLogo(tip.homeTeamId),
                      placeholder: Assets.teamLogoPlaceholder,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Expanded(
                    child: Text(
                      tip.homeTeamName,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: DefaultValues.padding / 4,
                      horizontal: DefaultValues.padding / 2,
                    ),
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: context.colorScheme.primary
                    ),
                    child: Text(
                      Utils.formatDateTime(
                        DateTime.fromMillisecondsSinceEpoch(tip.fixtureTimestamp * 1000),
                        'HH:mm',
                      ),
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Expanded(
                    child: Text(
                      tip.awayTeamName,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Container(
                    height: 40.h,
                    width: 40.h,
                    clipBehavior: Clip.antiAlias,
                    padding: EdgeInsets.all(DefaultValues.padding / 4),
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.primary,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: Utils.teamLogo(tip.awayTeamId),
                      placeholder: Assets.teamLogoPlaceholder,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(DefaultValues.padding / 2),
            color: context.colorScheme.secondaryContainer.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(tip.betName)),
                    Gap(DefaultValues.spacing / 2),
                    BetValueWidget(
                      betValue: tip.betValue,
                      expand: false,
                    ),
                  ],
                ),
                if (tip.description != null &&
                    (tip.description?.isNotEmpty ?? false) &&
                    !preview) ...[
                  Divider(
                    color: context.colorScheme.primary,
                    height: DefaultValues.spacing,
                  ),
                  ExpandableText(text: tip.description!),
                ],
              ],
            ),
          ),
          if (!preview)
            Padding(
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30.h,
                    width: 30.h,
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
                      imageUrl: tip.authorPicture,
                      placeholder: Assets.userPlaceholder,
                    ),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          String name;
                          if (tip.isMine) {
                            name = tip.authorName != null
                                ? '${tip.authorName} (${Strings.me})'
                                : Strings.me;
                          } else {
                            name = tip.authorName ?? Strings.unknown;
                          }
                          return Text(
                            name,
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                        Gap(DefaultValues.spacing / 4),
                        Text(
                          Utils.formatDateTime(tip.shareTime.toDate(), 'MMM dd, yyyy HH:mm'),
                          style: context.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Gap(DefaultValues.spacing),
                  StreamBuilder(
                    stream: context.read<TipsRepository>().checkLike(tip.id!),
                    builder: (context, snapshot) {
                      bool? isLiked;

                      if (snapshot.hasData) {
                        isLiked = snapshot.data?.data()?.isLiked;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikeButton(
                            isLiked: isLiked,
                            likes: tip.likes,
                            icon: soccer24Icons.thumbUp,
                            iconColor: isLiked ?? false
                                ? context.colorScheme.primary
                                : context.colorScheme.onSurface,
                            onPressed: () => context.read<TipsRepository>().updateLikes(
                                  tipId: tip.id!,
                                  isLike: true,
                                  delete: isLiked ?? false,
                                  switchLikes: isLiked != null,
                                ),
                          ),
                          Gap(DefaultValues.spacing / 2),
                          LikeButton(
                            isLiked: isLiked,
                            likes: tip.dislikes,
                            icon: soccer24Icons.thumbDown,
                            iconColor: !(isLiked ?? true)
                                ? context.colorScheme.primary
                                : context.colorScheme.onSurface,
                            onPressed: () => context.read<TipsRepository>().updateLikes(
                                  tipId: tip.id!,
                                  isLike: false,
                                  delete: !(isLiked ?? true),
                                  switchLikes: isLiked != null,
                                ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
