import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../_package_info/app_info.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DefaultValues.radius),
            color: context.colorScheme.secondaryContainer,
          ),
          child: Image.asset(
            AppInfo.icon,
            height: .4.sw,
            width: .4.sw,
          ),
        ),
        Gap(DefaultValues.spacing),
        Text(
          AppInfo.name,
          style: context.textTheme.titleLarge,
        ),
      ],
    );
  }
}