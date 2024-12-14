import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'field_widget.dart';
import 'team_start_ix_widget.dart';

class MatchStartXIField extends StatelessWidget {
  const MatchStartXIField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 2.sw,
      child: const Stack(
        children: [
          FieldWidget(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TeamStartXIWidget(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TeamStartXIWidget(
              isHomeTeam: false,
            ),
          ),
        ],
      ),
    );
  }
}
