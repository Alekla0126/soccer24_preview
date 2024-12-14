import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';


class StatisticWidget extends StatelessWidget {
  const StatisticWidget({super.key, required this.text, required this.value});

  final String text, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}