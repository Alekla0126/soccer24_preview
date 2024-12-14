import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../extensions/enums.dart';


class EventIcon extends StatelessWidget {
  const EventIcon({super.key, required this.type, required this.detail});

  final FixtureEventType? type;
  final FixtureEventDetail? detail;

  @override
  Widget build(BuildContext context) {
    String iconPath = '';
    switch (type) {
      case FixtureEventType.card:
        switch (detail) {
          case FixtureEventDetail.yellowCard:
            iconPath = Assets.yellowCardIconPath;
            break;
          case FixtureEventDetail.redCard:
            iconPath = Assets.redCardIconPath;
            break;
          default:
            break;
        }
        break;
      case FixtureEventType.goal:
        switch (detail) {
          case FixtureEventDetail.normalGoal:
            iconPath = Assets.goalIconPath;
            break;
          case FixtureEventDetail.ownGoal:
            iconPath = Assets.ownGoalIconPath;
            break;
          case FixtureEventDetail.penalty:
            iconPath = Assets.penaltyIconPath;
            break;
          case FixtureEventDetail.missedPenalty:
            iconPath = Assets.missedPenaltyIconPath;
            break;
          default:
            break;
        }
        break;
      case FixtureEventType.subst:
        iconPath = Assets.substituteIconPath;
        break;
      case FixtureEventType.vidAR:
        iconPath = Assets.varIconPath;
        break;
      default:
        break;
    }

    return Image.asset(iconPath);
  }
}