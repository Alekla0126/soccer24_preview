import '../../features/football_api/models/fixture/fixture_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'shadowless_card.dart';
import 'custom_image.dart';


class PredictionH2HFixtureWidget extends StatelessWidget {
  const PredictionH2HFixtureWidget({super.key, required this.fixture, this.backgroundColor});

  final FixtureDetails fixture;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      color: backgroundColor ?? AppColors.transparent,
      opacity: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DefaultValues.padding / 2,
          vertical: DefaultValues.padding / 4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                Utils.formatDateTime(
                    DateTime.fromMillisecondsSinceEpoch(fixture.fixture.timestamp * 1000),
                    'MMM dd, yyyy HH:mm'),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 25.h,
                  width: 25.h,
                  padding: EdgeInsets.all(DefaultValues.padding / 4),
                  clipBehavior: Clip.antiAlias,
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
                Gap(DefaultValues.spacing / 2),
                RichText(
                  text: TextSpan(
                    style: context.textTheme.bodyMedium,
                    children: [
                      TextSpan(text: '${fixture.goals.home ?? '*'}'),
                      const TextSpan(text: ' - '),
                      TextSpan(text: '${fixture.goals.away ?? '*'}'),
                    ],
                  ),
                ),
                Gap(DefaultValues.spacing / 2),
                Container(
                  height: 25.h,
                  width: 25.h,
                  padding: EdgeInsets.all(DefaultValues.padding / 4),
                  clipBehavior: Clip.antiAlias,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}