import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';


class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: context.colorScheme.primary,
            endIndent: DefaultValues.spacing / 2,
            indent: DefaultValues.spacing * 3,
            thickness: 2,
          ),
        ),
        Text(
          text,
          style: style,
          maxLines: 1,
        ),
        Expanded(
          child: Divider(
            color: context.colorScheme.primary,
            endIndent: DefaultValues.spacing * 3,
            indent: DefaultValues.spacing / 2,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}