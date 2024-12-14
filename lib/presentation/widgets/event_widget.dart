import '../../features/football_api/models/events/fixture_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../extensions/enums.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'custom_image.dart';
import 'event_icon.dart';


class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.event, required this.isHomeEvent});

  final FixtureEvent event;
  final bool isHomeEvent;

  @override
  Widget build(BuildContext context) {
    String time = '';
    if (event.time?.elapsed != null) {
      time += '${event.time!.elapsed}\'';
    }
    if (event.time?.extra != null) {
      time += '+${event.time!.extra}';
    }

    List<Widget> player = [
      Container(
        height: 35.h,
        width: 35.h,
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: CustomNetworkImage(
          imageUrl: Utils.playerImage(event.player?.id),
          placeholder: Assets.playerPlaceholder,
        ),
      ),
      Gap(DefaultValues.spacing / 2),
      Column(
        crossAxisAlignment: isHomeEvent ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            event.player?.name ?? '-',
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (event.assist?.name != null) _assistWidget(context),
          if (event.comments != null)
            Text(
              event.comments ?? '-',
              style: context.textTheme.bodySmall,
            ),
        ],
      ),
    ];

    if (!isHomeEvent) {
      player = player.reversed.toList(growable: false);
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: DefaultValues.padding / 2,
        vertical: DefaultValues.padding / 4,
      ),
      child: Row(
        children: [
          Container(
            width: 45.h,
            height: 20.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              vertical: DefaultValues.padding / 8,
              horizontal: DefaultValues.padding / 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
              color: context.colorScheme.secondaryContainer,
            ),
            child: Text(
              time,
              style: context.textTheme.labelMedium,
              maxLines: 1,
            ),
          ),
          Gap(DefaultValues.spacing),
          SizedBox(
            height: 15.h,
            width: 15.h,
            child: EventIcon(
              type: event.type,
              detail: event.detail,
            ),
          ),
          Gap(DefaultValues.spacing),
          Expanded(
            child: Row(
              mainAxisAlignment: isHomeEvent ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: player,
            ),
          ),
        ],
      ),
    );
  }

  Widget _assistWidget(BuildContext context) {
    if (event.type == FixtureEventType.goal) {
      var children = [
        Text(
          event.assist?.name ?? '-',
          style: context.textTheme.bodySmall,
        ),
        Gap(DefaultValues.spacing / 4),
        Transform.flip(
          flipX: !isHomeEvent,
          child: Image.asset(
            Assets.assistIconPath,
            height: 16.h,
            width: 16.r,
          ),
        ),
      ];

      if (!isHomeEvent) {
        children = children.reversed.toList(growable: false);
      }

      return Row(
        children: children,
      );
    }
    return Text(
      event.assist?.name ?? '-',
      style: context.textTheme.bodySmall,
    );
  }
}