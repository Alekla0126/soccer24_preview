import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/bet_smart_icons.dart';
import '../../extensions/extensions.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    this.subtitle,
    this.trailing,
    this.iconSize,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData leading;
  final IconData? trailing;
  final double? iconSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      subtitleTextStyle: context.textTheme.bodySmall,
      titleTextStyle: context.textTheme.bodyLarge,
      leading: Icon(leading, size: iconSize),
      trailing: Icon(
        trailing ?? soccer24Icons.arrowRight,
        size: 12.r,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}
