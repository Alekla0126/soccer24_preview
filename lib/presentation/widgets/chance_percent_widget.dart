import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';

class ChancePercentWidget extends StatelessWidget {
  const ChancePercentWidget({
    super.key,
    required this.title,
    required this.percent,
  });

  final String title;
  final String? percent;

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
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          side: BorderSide(color: context.colorScheme.primary),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: context.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
          VerticalDivider(color: context.colorScheme.primary),
          Expanded(
            flex: 2,
            child: Text(
              percent ?? '-',
              style: context.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
