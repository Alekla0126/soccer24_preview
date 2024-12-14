import '../../features/tips/repositories/tips_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/ads/applovin/applovin_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import '../screens/tips/tips_list.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import 'package:intl/intl.dart';
import 'loading_widget.dart';


class TipsCountBadge extends StatelessWidget {
  const TipsCountBadge({super.key, required this.fixtureId});

  final int fixtureId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: ValueKey(fixtureId),
      future: context.read<TipsRepository>().getFixtureTips(fixtureId).count().get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 20.h,
            width: 20.h,
            child: const LoadingWidget(),
          );
        }

        if (snapshot.hasData && (snapshot.data?.count ?? 0) > 0) {
          final numberFormat = NumberFormat.compact();
          numberFormat.maximumFractionDigits = 0;

          return badges.Badge(
            onTap: () => _showTipsBottomSheet(context),
            badgeAnimation: const badges.BadgeAnimation.scale(),
            position: badges.BadgePosition.topEnd(),
            badgeContent: Text(
              numberFormat.format(snapshot.data!.count!),
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: context.colorScheme.primaryContainer,
              shape: badges.BadgeShape.circle,
            ),
            child: IconButton(
              onPressed: () => _showTipsBottomSheet(context),
              icon: Icon(
                soccer24Icons.tips,
                color: context.colorScheme.primary,
                size: 20.r,
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showTipsBottomSheet(BuildContext context) {
    context.read<ApplovinManager>().showInterstitialAd();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Text(
                Strings.availableTips,
                style: context.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: TipsList(
                query: context.read<TipsRepository>().getFixtureTips(fixtureId),
              ),
            ),
          ],
        );
      },
    );
  }
}