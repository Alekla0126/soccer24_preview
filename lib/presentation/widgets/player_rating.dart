import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';

class PlayerRating extends StatelessWidget {
  const PlayerRating({super.key, required this.rating, this.style, this.padding});

  final String rating;
  final TextStyle? style;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final double dRating;
    try {
      dRating = double.parse(rating);
    } catch (_) {
      return const SizedBox.shrink();
    }

    final Color color;

    if (dRating < 5) {
      color = AppColors.redColor;
    } else if (dRating >= 5 && dRating < 7) {
      color = AppColors.orangeColor;
    } else if (dRating < 9) {
      color = AppColors.greenColor;
    } else if (dRating <= 10) {
      color = AppColors.blueColor;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: DefaultValues.spacing / 4,
            vertical: DefaultValues.spacing / 8,
          ),
      decoration: ShapeDecoration(
        shape: StadiumBorder(side: BorderSide(color: context.colorScheme.primary, width: .5)),
        color: color,
      ),
      child: Text(
        dRating.toStringAsFixed(1),
        style: style ?? context.textTheme.labelSmall?.copyWith(fontSize: 9.r),
      ),
    );
  }
}
