import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../_utils/utils.dart';
import '../../constants/constants.dart';
import '../../constants/strings.dart';
import '../../extensions/extensions.dart';

class AcceptTerms extends StatelessWidget {
  const AcceptTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.textTheme.bodyLarge,
        children: [
          const TextSpan(text: Strings.accept1),
          TextSpan(
            text: Strings.termsOfService,
            style: style?.copyWith(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await Utils.openLink(Constants.termsUrl);
              },
          ),
          const TextSpan(text: Strings.accept2),
          TextSpan(
            text: Strings.privacyPolicy,
            style: style?.copyWith(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await Utils.openLink(Constants.privacyUrl);
              },
          ),
        ],
      ),
    );
  }
}
