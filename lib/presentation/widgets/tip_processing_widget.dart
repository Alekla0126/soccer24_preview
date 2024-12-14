import '../../features/tips/repositories/tips_repository.dart';
import '../../features/tips/blocs/tip_cubit/tip_cubit.dart';
import '../../features/tips/models/tip_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'outlined_text_form_field.dart';
import '../../constants/strings.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'tip_card.dart';


class TipProcessingWidget extends StatefulWidget {
  const TipProcessingWidget({super.key, required this.tip});

  final Tip tip;

  @override
  State<TipProcessingWidget> createState() => _TipProcessingWidgetState();
}

class _TipProcessingWidgetState extends State<TipProcessingWidget> {
  late final TextEditingController _descriptionController;
  late Tip tip;
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    tip = widget.tip;
    isEditing = tip.id != null;
    _descriptionController = TextEditingController(text: tip.description);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + DefaultValues.padding / 2,
        ),
        child: BlocProvider(
          create: (context) => TipCubit(context.read<TipsRepository>()),
          child: BlocConsumer<TipCubit, TipProcessingState>(
            listener: (context, state) {
              if (state is TipProcessing) {
                Utils.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: context.colorScheme.secondary,
                  textColor: context.colorScheme.onSecondary,
                );
              }
              if (state is TipProcessingError) {
                Utils.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: context.colorScheme.errorContainer,
                  textColor: context.colorScheme.onErrorContainer,
                );
              }
              if (state is TipProcessingSuccess) {
                Navigator.of(context).pop();
                Utils.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: context.colorScheme.primary,
                  textColor: context.colorScheme.onPrimary,
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Text(
                    Strings.shareTip,
                    style: context.textTheme.titleLarge,
                  ),
                  Gap(DefaultValues.spacing / 2),
                  TipCard(
                    tip: widget.tip,
                    preview: true,
                  ),
                  Gap(DefaultValues.spacing / 2),
                  OutlinedTextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    radius: DefaultValues.radius / 2,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: Strings.explainTip,
                    onChanged: (description) {},
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Row(
                    children: [
                      if (isEditing) ...[
                        Expanded(
                          child: FilledButton(
                            onPressed: () => context.read<TipCubit>().deleteTip(tip.id!),
                            style: FilledButton.styleFrom(
                              backgroundColor: context.colorScheme.error,
                              foregroundColor: context.colorScheme.onError,
                            ),
                            child: Text(Strings.deleteTip.toUpperCase()),
                          ),
                        ),
                        Gap(DefaultValues.spacing / 4),
                      ],
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            tip = tip.copyWith(
                              description: _descriptionController.text,
                            );

                            context.read<TipCubit>().saveTip(tip);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: context.colorScheme.onPrimary,
                          ),
                          child:
                              Text((isEditing ? Strings.saveTip : Strings.shareTip).toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}