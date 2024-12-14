import '../../features/football_api/models/odds/bet_value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';


class BetValueWidget extends StatelessWidget {
  const BetValueWidget({
    super.key,
    required this.betValue,
    this.expand = true,
  });

  final BetValue betValue;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: DefaultValues.padding / 2,
        vertical: DefaultValues.padding / 4,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: context.colorScheme.primary),
        ),
      ),
      child: Row(
        children: [
          if (expand)
            Expanded(
              child: Text(
                betValue.value,
                style: context.textTheme.labelMedium?.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
          if (!expand)
            Text(
              betValue.value,
              style: context.textTheme.labelMedium?.copyWith(),
              textAlign: TextAlign.center,
            ),
          VerticalDivider(color: context.colorScheme.primary),
          Text(
            betValue.odd.toStringAsPrecision(3),
            style: context.textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}