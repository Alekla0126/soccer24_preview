import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/authentication/blocs/password_reset_cubit/password_reset_cubit.dart';
import '../../widgets/app_info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/outlined_text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final TextEditingController emailController;

  const ResetPasswordScreen({super.key, required this.emailController});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ForgotPasswordFormState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(DefaultValues.padding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    const AppInfoWidget(),
                    const Expanded(child: SizedBox.shrink()),
                    Gap(DefaultValues.spacing),
                    Text(
                      Strings.forgotPasswordMsg,
                      style: context.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    Gap(DefaultValues.spacing * 2),
                    OutlinedTextFormField(
                      controller: widget.emailController,
                      labelText: Strings.email,
                      hintText: Strings.emailHint,
                      textInputAction: TextInputAction.done,
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
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size.fromHeight(DefaultValues.buttonHeight),
                        textStyle: context.textTheme.bodyLarge,
                      ),
                      onPressed: _canSendEmail(state) ? () => _validateAndSubmit() : null,
                      child: Text(state is PasswordResetSent
                          ? Strings.retryIn.replaceAll('##', '${state.retryIn}')
                          : Strings.sendResetEmail),
                    ),
                    Gap(DefaultValues.spacing),
                    if (state is PasswordResetSent)
                      Text(
                        Strings.emailSent,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (state is PasswordResetSending) const LoadingWidget(),
                    if (state is PasswordResetError)
                      Text(
                        Strings.emailNotSent,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _canSendEmail(PasswordResetState state) {
    if (state is PasswordResetSending || state is PasswordResetSent) {
      return false;
    }
    return true;
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<PasswordResetCubit>().verifyUserEmail(widget.emailController.text);
    }
  }
}
