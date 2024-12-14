import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../features/ads/ads_manager.dart';

class BannerAdInjector extends StatelessWidget {
  const BannerAdInjector({
    super.key,
    required this.condition,
    this.mrec = false,
    this.spacing = 0.0,
    required this.child,
  });

  final bool condition;
  final bool mrec;
  final double spacing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          Gap(spacing),
          mrec ? AdsManager.instance.mrecAd() : AdsManager.instance.bannerAd(),
        ],
      );
    }
    return child;
  }
}
