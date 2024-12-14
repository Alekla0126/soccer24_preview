import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import '../../widgets/outlined_text_form_field.dart';
import '../../../../constants/bet_smart_icons.dart';
import '../../../../constants/default_values.dart';
import '../../../../extensions/extensions.dart';
import '../../../../constants/strings.dart';
import '../../widgets/app_info_widget.dart';
import 'package:flutter/material.dart';
import 'reset_password_screen.dart';
import 'package:gap/gap.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onSignInWithGoogle,
    required this.onRegister,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function()? onSignIn;
  final Function()? onSignInWithGoogle;
  final Function() onRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignInFormState');
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
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
                  OutlinedTextFormField(
                    controller: widget.emailController,
                    labelText: Strings.email,
                    hintText: Strings.emailHint,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email?.isEmpty ?? true) {
                        return Strings.emptyEmail;
                      }
                      if (!EmailValidator.validate(email ?? '')) {
                        return Strings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  Gap(DefaultValues.spacing / 2),
                  OutlinedTextFormField(
                    controller: widget.passwordController,
                    labelText: Strings.password,
                    hintText: Strings.passwordHint,
                    obscureText: _hidePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(
                        _hidePassword ? soccer24Icons.visibility : soccer24Icons.visibilityOff,
                      ),
                    ),
                    onFieldSubmitted: (_) => _validateAndSubmit(),
                    validator: (password) {
                      if (password?.isEmpty ?? true) {
                        return Strings.emptyPassword;
                      }
                      if ((password ?? '').length < 8) {
                        return Strings.invalidPassword;
                      }
                      return null;
                    },
                  ),
                  Gap(DefaultValues.spacing / 2),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: () => context.goTo(
                        ResetPasswordScreen(emailController: widget.emailController), false),
                    child: const Text(Strings.forgotPassword),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text(Strings.signIn),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: widget.onSignInWithGoogle,
                    icon: const Icon(FontAwesomeIcons.google),
                    label: const Text(Strings.signInWithGoogle),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: widget.onRegister,
                    child: const Text(Strings.register),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    if (widget.onSignIn == null) return;
    if (_formKey.currentState!.validate()) {
      widget.onSignIn!();
    }
  }
}