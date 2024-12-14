import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.text,
    this.message,
    required this.icon,
    this.iconSize,
    this.color,
    this.onButtonTaped,
    this.buttonText,
    this.padding,
  }) : assert(
          (onButtonTaped == null && buttonText == null) ||
              (onButtonTaped != null && buttonText != null),
          '[buttonText] should be set if [onButtonTaped] is not null',
        );

  final String text;
  final String? message;
  final IconData icon;
  final double? iconSize;
  final Color? color;
  final Function()? onButtonTaped;
  final String? buttonText;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize ?? 80.r,
              color: color ?? context.colorScheme.primary,
            ),
            Gap(DefaultValues.spacing),
            Text(
              text,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              Gap(DefaultValues.spacing),
              Text(
                message!,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onButtonTaped != null) ...[
              Gap(DefaultValues.spacing),
              FilledButton(
                onPressed: onButtonTaped,
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
