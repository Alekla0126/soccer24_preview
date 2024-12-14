import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/assets.dart';


class FieldWidget extends StatelessWidget {
  const FieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.fieldSvg,
      fit: BoxFit.fill,
    );
  }
}