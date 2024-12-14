import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/assets.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import '../../features/football_api/models/leagues/league_model.dart';
import '../screens/league/league_screen.dart';
import 'custom_image.dart';
import 'info_widget.dart';
import 'league_widget.dart';
import 'shadowless_card.dart';

class LeaguesCard extends StatelessWidget {
  const LeaguesCard({super.key, required this.leagues, this.title, this.icon, this.emptyMessage});

  final List<LeagueModel> leagues;
  final String? title;
  final String? emptyMessage;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      child: Theme(
        data: context.theme.copyWith(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: DefaultValues.padding / 2,
          ),
          leading: Container(
            height: 28.h,
            width: 28.h,
            clipBehavior: Clip.hardEdge,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: context.colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
            ),
            child: icon ??
                CustomNetworkImage(
                  imageUrl: leagues[0].country.flag,
                  placeholder: Assets.countryLogoPlaceholder,
                ),
          ),
          title: Text(title ?? leagues[0].country.name),
          children: leagues.isEmpty && emptyMessage != null
              ? [
                  InfoWidget(
                    iconSize: 40.r,
                    text: emptyMessage!,
                    icon: soccer24Icons.empty,
                    color: context.colorScheme.secondaryContainer,
                    padding: EdgeInsets.all(DefaultValues.padding),
                  ),
                ]
              : List<Widget>.generate(
                  leagues.length,
                  (index) {
                    final league = leagues[index];
                    return Padding(
                      padding: EdgeInsets.all(
                        DefaultValues.padding / 4,
                      ).copyWith(left: DefaultValues.padding * 2),
                      child: LeagueWidget(
                        key: ValueKey(league.league.id),
                        league: league,
                        onTap: () => context.goTo(LeagueScreen(league: league)),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
