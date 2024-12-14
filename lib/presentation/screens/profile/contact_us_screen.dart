import 'package:email_validator/email_validator.dart';
import '../../widgets/outlined_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/default_values.dart';
import '../../../extensions/extensions.dart';
import '../../../constants/strings.dart';
import '../../../extensions/enums.dart';
import 'package:flutter/material.dart';
import '../../../_utils/utils.dart';
import 'package:gap/gap.dart';


class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignInFormState');
  final TextEditingController _emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email ?? '');
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  MessageReason _messageType = MessageReason.bugReport;

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.contactUs),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DefaultValues.padding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: DefaultValues.padding),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colorScheme.primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
                ),
                child: DropdownButton<MessageReason>(
                  isExpanded: true,
                  elevation: 0,
                  underline: const SizedBox.shrink(),
                  value: _messageType,
                  items: List<DropdownMenuItem<MessageReason>>.generate(
                    MessageReason.values.length,
                    (index) => DropdownMenuItem(
                      value: MessageReason.values[index],
                      child: Text(MessageReason.values[index].asString),
                    ),
                  ).toList(growable: false),
                  onChanged: (type) {
                    setState(() {
                      _messageType = type ?? _messageType;
                    });
                  },
                ),
              ),
              Gap(DefaultValues.spacing),
              OutlinedTextFormField(
                controller: _emailController,
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
              Gap(DefaultValues.spacing),
              OutlinedTextFormField(
                controller: _subjectController,
                labelText: Strings.subject,
                hintText: Strings.subject,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (subject) {
                  if (subject?.isEmpty ?? true) {
                    return Strings.subjectRequired;
                  }
                  return null;
                },
              ),
              Gap(DefaultValues.spacing),
              OutlinedTextFormField(
                controller: _bodyController,
                hintText: Strings.message,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                validator: (message) {
                  return null;
                },
              ),
              Gap(DefaultValues.spacing),
              FractionallySizedBox(
                widthFactor: 1,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Utils.sendEmail(
                        messageReason: _messageType,
                        senderEmail: _emailController.text,
                        subject: _subjectController.text,
                        body: _bodyController.text,
                      );
                    }
                  },
                  child: const Text(Strings.sendMessage),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}