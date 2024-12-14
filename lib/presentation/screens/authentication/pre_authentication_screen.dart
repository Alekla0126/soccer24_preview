import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/default_values.dart';
import '../../../../extensions/extensions.dart';
import '../../../../constants/strings.dart';
import '../../widgets/app_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:io';

class PreAuthenticationScreen extends StatelessWidget {
  const PreAuthenticationScreen({
    super.key,
    required this.onSignIn,
    required this.onRegister,
    this.onSignInWithGoogle,
    this.onSignInWithAnonymously,
    this.onSignInWithApple,
  });

  final Function() onSignIn;
  final Function()? onSignInWithGoogle;
  final Function() onRegister;
  final Function()? onSignInWithAnonymously;
  final Function()? onSignInWithApple;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: .5.sh,
            padding: EdgeInsets.all(DefaultValues.padding),
            child: const Column(
              children: [
                Expanded(child: SizedBox.shrink()),
                AppInfoWidget(),
                Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(DefaultValues.padding),
            color: context.colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(DefaultValues.spacing / 2),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                    textStyle: context.textTheme.bodyLarge,
                  ),
                  onPressed: onSignIn,
                  child: const Text(Strings.signIn),
                ),
                Gap(DefaultValues.spacing / 2),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                    textStyle: context.textTheme.bodyLarge,
                  ),
                  onPressed: onRegister,
                  child: const Text(Strings.createAccount),
                ),
                Gap(DefaultValues.spacing / 2),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                    textStyle: context.textTheme.bodyLarge,
                  ),
                  onPressed: onSignInWithGoogle,
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 20.0, // Adjust the size as needed
                  ),
                  label: const Text(Strings.signInWithGoogle),
                ),
                Gap(DefaultValues.spacing / 2),
                // If the platform is iOS, show the sign in with Apple button
                if (Platform.isIOS)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: onSignInWithApple,
                    icon: const Icon(
                      FontAwesomeIcons.apple,
                      size: 20.0, // Adjust the size as needed
                    ),
                    label: const Text(Strings.signInWithApple),
                  ),
                Gap(DefaultValues.spacing / 2),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                    textStyle: context.textTheme.bodyLarge,
                  ),
                  onPressed: onSignInWithAnonymously,
                  child: const Text(Strings.continueAnonymous),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
