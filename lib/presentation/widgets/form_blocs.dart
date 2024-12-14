import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../constants/colors.dart';
import 'package:gap/gap.dart';


class FormBlocs extends StatelessWidget {
  const FormBlocs({
    super.key,
    required this.form,
    this.showTitle = true,
    this.limit,
    this.textStyle,
  });

  final String form;
  final int? limit;
  final bool showTitle;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (form.isEmpty) return const SizedBox.shrink();
    final List<String> formList = form.lastChars(limit ?? 5).split('').toList(growable: false);

    final Widget formRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        formList.length,
        (index) => _formBlock(formList[index]),
      ),
    );
    return Center(
      child: !showTitle
          ? formRow
          : Column(
              children: [
                Text(
                  Strings.lastMatches.replaceAll('##', '${formList.length}'),
                ),
                Gap(DefaultValues.spacing / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    formList.length,
                    (index) => _formBlock(formList[index]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _formBlock(String i) {
    final Color color;
    switch (i) {
      case 'W':
        color = AppColors.greenColor;
        break;
      case 'D':
        color = AppColors.orangeColor;
        break;
      case 'L':
        color = AppColors.redColor;
        break;
      default:
        color = AppColors.orangeColor;
        break;
    }
    return Container(
      width: 20.h,
      height: 20.h,
      alignment: Alignment.center,
      padding: EdgeInsets.all(DefaultValues.padding / 4),
      margin: EdgeInsets.symmetric(horizontal: DefaultValues.padding / 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
        color: color,
      ),
      child: Text(i, style: textStyle),
    );
  }
}