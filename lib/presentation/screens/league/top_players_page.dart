import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/assets.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/top_players_bloc/top_players_bloc.dart';
import 'top_player_page.dart';

class TopPlayersPageView extends StatefulWidget {
  const TopPlayersPageView({super.key, required this.leagueId, required this.season});

  final int leagueId;
  final int season;

  @override
  State<TopPlayersPageView> createState() => _TopPlayersPageViewState();
}

class _TopPlayersPageViewState extends State<TopPlayersPageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: DefaultValues.padding / 4,
            vertical: DefaultValues.padding / 2,
          ),
          child: Wrap(
            spacing: DefaultValues.spacing / 4,
            runSpacing: DefaultValues.spacing / 4,
            alignment: WrapAlignment.end,
            children: List<Widget>.generate(
              _statsIcons.length,
              (index) {
                final bool isSelected = _currentPage == index;
                return ChoiceChip(
                  showCheckmark: false,
                  padding: EdgeInsets.all(DefaultValues.padding / 4),
                  side: BorderSide(color: context.colorScheme.secondaryContainer),
                  labelStyle: context.textTheme.labelSmall,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        _statsIcons[index],
                        height: 15.r,
                        width: 15.r,
                      ),
                      AnimatedContainer(
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 800),
                        width: isSelected ? null : 0,
                        margin: isSelected
                            ? EdgeInsets.only(left: DefaultValues.padding / 4)
                            : EdgeInsets.zero,
                        child: Text(
                          _statsNames[index],
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (!selected) return;
                    setState(() {
                      _currentPage = index;
                    });
                    _pageController.jumpToPage(_currentPage);
                  },
                );
              },
            ),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: List<Widget>.generate(_events.length, (pageIndex) {
              return TopPlayerPage(event: _events[pageIndex], pageIndex: pageIndex);
            }),
          ),
        ),
      ],
    );
  }

  final List<String> _statsIcons = [
    Assets.goalIconPath,
    Assets.assistIconPath,
    Assets.yellowCardIconPath,
    Assets.redCardIconPath,
  ];

  final List<String> _statsNames = [
    Strings.topScorers,
    Strings.topAssists,
    Strings.topYellowCards,
    Strings.topRedCards,
  ];

  List<TopPlayersEvent> get _events => [
        TopScorersEvent(widget.leagueId, widget.season),
        TopAssistsEvent(widget.leagueId, widget.season),
        TopYellowCardsEvent(widget.leagueId, widget.season),
        TopRedCardsEvent(widget.leagueId, widget.season),
      ];
}

