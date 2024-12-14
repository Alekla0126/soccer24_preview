import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:gap/gap.dart';


class CompareWidget extends StatelessWidget {
  const CompareWidget({
    super.key,
    required this.title,
    required this.homeValue,
    required this.awayValue,
    this.homeBaseCount = 100,
    this.awayBaseCount = 100,
  });

  final String title;
  final String homeValue;
  final String awayValue;
  final int homeBaseCount;
  final int awayBaseCount;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        double homeValueAsDouble;
        double awayValueAsDouble;

        try {
          homeValueAsDouble = double.parse(homeValue.replaceAll('%', ''));
        } catch (_) {
          homeValueAsDouble = 0;
        }

        try {
          awayValueAsDouble = double.parse(awayValue.replaceAll('%', ''));
        } catch (_) {
          awayValueAsDouble = 0;
        }

        return Padding(
          padding: EdgeInsets.all(DefaultValues.padding / 2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeValue,
                    style: context.textTheme.bodySmall,
                  ),
                  Gap(DefaultValues.spacing),
                  Text(
                    title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(DefaultValues.spacing),
                  Text(
                    awayValue,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              Gap(DefaultValues.spacing / 2),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double height = 10.h;
                  final double halfWidth = constraints.maxWidth / 2;
                  final double homeBlankWidth = halfWidth -
                      ((halfWidth * homeValueAsDouble) / (homeBaseCount == 0 ? 1 : homeBaseCount));
                  final double awayBlankWidth = halfWidth -
                      (halfWidth * awayValueAsDouble / (awayBaseCount == 0 ? 1 : awayBaseCount));
                  return Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: height,
                              width: homeBlankWidth > 0 ? homeBlankWidth : 0,
                              color: context.colorScheme.tertiaryContainer,
                            ),
                            Container(
                              height: height,
                              width: (halfWidth * homeValueAsDouble) /
                                  (homeBaseCount == 0 ? 1 : homeBaseCount),
                              color: homeValueAsDouble == awayValueAsDouble
                                  ? AppColors.orangeColor
                                  : homeValueAsDouble > awayValueAsDouble
                                      ? AppColors.greenColor
                                      : AppColors.redColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: height,
                              width: (halfWidth *
                                  awayValueAsDouble /
                                  (awayBaseCount == 0 ? 1 : awayBaseCount)),
                              color: homeValueAsDouble == awayValueAsDouble
                                  ? AppColors.orangeColor
                                  : homeValueAsDouble < awayValueAsDouble
                                      ? AppColors.greenColor
                                      : AppColors.redColor,
                            ),
                            Container(
                              height: height,
                              width: awayBlankWidth,
                              color: context.colorScheme.tertiaryContainer,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}