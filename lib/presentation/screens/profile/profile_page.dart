import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../_utils/utils.dart';
import '../../../constants/assets.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/constants.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import '../../../features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../widgets/change_theme_dialog.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_list_tile.dart';
import '../tips/my_tips_screen.dart';
import 'contact_us_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Column(
                children: [
                  Container(
                    width: 80.h,
                    height: 80.h,
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.secondaryContainer,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: state.user.photoURL,
                      placeholder: Assets.userPlaceholder,
                    ),
                  ),
                  if (FirebaseAuth.instance.currentUser!.isAnonymous)
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: DefaultValues.padding / 4,
                        horizontal: DefaultValues.padding / 2,
                      ),
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: context.colorScheme.error,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Strings.anonymous,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onError,
                            ),
                          ),
                          Gap(DefaultValues.spacing / 4),
                          Tooltip(
                            message: Strings.anonymousMsg,
                            preferBelow: false,
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 5),
                            margin: EdgeInsets.symmetric(horizontal: .2.sw),
                            textAlign: TextAlign.center,
                            textStyle: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onError,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.error,
                              borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
                            ),
                            child: Icon(
                              soccer24Icons.info,
                              size: 12.r,
                              color: context.colorScheme.onError,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Gap(DefaultValues.spacing),
                  Text(
                    _getName(state.user.name).toUpperCase(),
                    style: context.textTheme.titleLarge,
                  ),
                  if (state.user.email != null) ...[
                    Gap(DefaultValues.spacing / 2),
                    Text(
                      state.user.email!,
                      style: context.textTheme.titleMedium,
                    ),
                  ],
                ],
              ),
            ),
            Divider(
              height: DefaultValues.spacing / 4,
              color: context.colorScheme.primaryContainer,
              thickness: 2,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  CustomListTile(
                    onTap: () async => context.goTo(const MyTipsScreen()),
                    title: Strings.myTips,
                    leading: soccer24Icons.tips,
                  ),
                  //Theme
                  CustomListTile(
                    onTap: () async => showDialog(
                      context: context,
                      builder: (context) => const ChangeThemeDialog(),
                    ),
                    title: Strings.theme,
                    subtitle: AdaptiveTheme.of(context).mode.modeName,
                    leading: soccer24Icons.themeFill,
                  ),
                  //FAQ
                  // CustomListTile(
                  //   onTap: () async => await Utils.openLink(Constants.faqUrl),
                  //   title: Strings.faq,
                  //   leading: soccer24Icons.faq,
                  // ),
                  //Rate us
                  CustomListTile(
                    onTap: () async => await Utils.rateApp(),
                    title: Strings.rateUs,
                    iconSize: 22.r,
                    leading: soccer24Icons.rate,
                  ),
                  //Share
                  CustomListTile(
                    onTap: () async => await Utils.shareApp(),
                    title: Strings.share,
                    iconSize: 22.r,
                    leading: soccer24Icons.share,
                  ),
                  //Privacy
                  CustomListTile(
                    onTap: () async => await Utils.openLink(Constants.privacyUrl),
                    title: Strings.privacy,
                    leading: soccer24Icons.privacy,
                  ),
                  //Terms
                  CustomListTile(
                    onTap: () async => await Utils.openLink(Constants.termsUrl),
                    title: Strings.terms,
                    iconSize: 22.r,
                    leading: soccer24Icons.terms,
                  ),
                  //Contact us
                  CustomListTile(
                    onTap: () => context.goTo(const ContactUsScreen(), false),
                    title: Strings.contactUs,
                    leading: soccer24Icons.email,
                  ),
                ],
              ),
            ),
            Gap(DefaultValues.spacing / 2),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: DefaultValues.padding),
              child: OutlinedButton(
                onPressed: () {
                  context.read<SignInBloc>().add(const SignOutEvent());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colorScheme.error,
                  side: BorderSide(color: context.colorScheme.error),
                ),
                child: const Text(Strings.logout),
              ),
            ),
            Gap(DefaultValues.spacing / 2),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: DefaultValues.padding),
              child: FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BlocConsumer<SignInBloc, SignInState>(
                        listener: (context, state) {
                          if (state is SignInSuccess) {
                            Navigator.maybePop(context);
                          }
                        },
                        builder: (context, state) {
                          return AlertDialog(
                            titleTextStyle: context.textTheme.titleLarge,
                            actionsAlignment: MainAxisAlignment.center,
                            title: Text(
                              Strings.deleteAccount,
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.colorScheme.error,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  Strings.deleteAccountWarning,
                                  textAlign: TextAlign.center,
                                ),
                                Gap(DefaultValues.spacing / 2),
                                if (state is SignInError) Text(state.message),
                                if (state is SignInLoading) const LinearProgressIndicator(),
                              ],
                            ),
                            actions: [
                              FilledButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(Strings.no),
                              ),
                              FilledButton(
                                onPressed: () {
                                  context.read<SignInBloc>().add(const DeleteAccountEvent());
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: context.colorScheme.error,
                                  foregroundColor: context.colorScheme.onError,
                                ),
                                child: const Text(Strings.yes),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                  foregroundColor: context.colorScheme.onError,
                ),
                child: const Text(Strings.deleteAccount),
              ),
            ),
            Gap(DefaultValues.spacing / 2),
          ],
        );
      },
    );
  }

  String _getName(String? name) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Strings.anonymous;
    } else {
      return FirebaseAuth.instance.currentUser!.displayName ?? name ?? '';
    }
  }
}
