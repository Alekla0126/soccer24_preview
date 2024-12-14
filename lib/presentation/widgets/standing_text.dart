import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';

class StandingText extends StatelessWidget {
  const StandingText({
    super.key,
    required this.title,
    required this.text,
    required this.isHeader,
    this.boldText = false,
  });

  final String title;
  final String text;
  final bool boldText;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Text(
      isHeader ? title : text,
      style: context.textTheme.bodySmall?.copyWith(
        color: isHeader ? null : context.colorScheme.onSurface,
        fontWeight: boldText ? FontWeight.bold : null,
      ),
      textAlign: TextAlign.center,
    );
  }
}
