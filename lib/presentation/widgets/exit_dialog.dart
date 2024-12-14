import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../_package_info/app_info.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';


class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key, required this.onExit});

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      titleTextStyle: context.textTheme.titleLarge,
      title: Row(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            height: 20.h,
            width: 20.h,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(DefaultValues.radius / 8)),
            child: Image.asset(AppInfo.icon),
          ),
          Gap(DefaultValues.spacing / 2),
          Text(AppInfo.name),
        ],
      ),
      content: const Text(Strings.exitMsg),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(Strings.no.toUpperCase()),
        ),
        TextButton(
          onPressed: () {
            onExit();
            Navigator.of(context).pop();
          },
          child: Text(Strings.yes.toUpperCase()),
        ),
        TextButton(
          onPressed: () async {
            await Utils.rateApp();
          },
          child: const Text(Strings.rate),
        ),
      ],
    );
  }
}