import 'package:flutter_bloc/flutter_bloc.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../extensions/enums.dart';


class ExpandableText extends StatelessWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.maxLength = 150,
    this.style,
    this.textAlign,
  });

  final String text;
  final int maxLength;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    String hintText = '';
    String textToShow = '';

    return BlocProvider(
      create: (ctx) => ExpandableTextCubit(text, maxLength),
      child: BlocBuilder<ExpandableTextCubit, ExpandableTextEvent>(
        builder: (context, state) {
          if (state == ExpandableTextEvent.collapsed) {
            hintText = ' ${Strings.showMore}';
            textToShow = '${text.substring(0, maxLength)}...';
          } else if (state == ExpandableTextEvent.expanded) {
            hintText = ' ${Strings.showLess}';
            textToShow = text;
          } else {
            hintText = '';
            textToShow = text;
          }
          return GestureDetector(
            onTap: () => context.read<ExpandableTextCubit>().switchExpansion(),
            child: RichText(
              textAlign: textAlign ?? TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: textToShow,
                    style: style ?? context.textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: hintText,
                    style: (style ?? context.textTheme.bodyMedium)?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExpandableTextCubit extends Cubit<ExpandableTextEvent> {
  ExpandableTextCubit(this.text, this.maxLength) : super(ExpandableTextEvent.collapsed) {
    checkTextLength();
  }

  final String text;
  final int maxLength;

  void checkTextLength() {
    emit(
      text.length < maxLength ? ExpandableTextEvent.nonExpandable : ExpandableTextEvent.collapsed,
    );
  }

  void switchExpansion() {
    if (state == ExpandableTextEvent.nonExpandable) {
      return;
    }
    emit(
      state == ExpandableTextEvent.expanded
          ? ExpandableTextEvent.collapsed
          : ExpandableTextEvent.expanded,
    );
  }
}