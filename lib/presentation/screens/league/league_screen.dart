import '../../../features/football_api/models/leagues/league_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/default_values.dart';
import '../../../features/ads/ads_manager.dart';
import '../../../extensions/extensions.dart';
import '../../../constants/strings.dart';
import '../fixture/standings_page.dart';
import '../fixtures/fixtures_page.dart';
import 'package:flutter/material.dart';
import '../../../_utils/utils.dart';
import 'top_players_page.dart';
import 'package:gap/gap.dart';


class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key, required this.league});

  final LeagueModel league;

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> with AutomaticKeepAliveClientMixin {
  late int _selectedSeason;

  @override
  void initState() {
    super.initState();
    try {
      _selectedSeason = widget.league.seasons.last.year;
    } catch (_) {
      _selectedSeason = DateTime.now().year;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.league.league.name),
          bottom: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: _tabs,
          ),
        ),
        bottomNavigationBar: AdsManager.instance.bannerAd(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.selectSeason,
                    style: context.textTheme.bodyLarge,
                  ),
                  Gap(DefaultValues.spacing),
                  Container(
                    width: 0.5.sw,
                    height: 30.h,
                    padding: EdgeInsets.symmetric(horizontal: DefaultValues.padding / 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
                      color: context.colorScheme.secondaryContainer,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
                        dropdownColor: context.colorScheme.secondaryContainer,
                        menuMaxHeight: .5.sh,
                        isExpanded: true,
                        style: context.textTheme.bodyLarge,
                        value: _selectedSeason,

                        items: List<DropdownMenuItem<int>>.generate(
                          widget.league.seasons.length,
                          (index) {
                            return DropdownMenuItem(
                              value: widget.league.seasons[index].year,
                              child: Text(
                                Utils.formatSeason(widget.league.seasons[index]),
                              ),
                            );
                          },
                        ),
                        onChanged: (s) => setState(() => _selectedSeason = s!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _views(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _tabs => [
        const Tab(text: Strings.matches),
        const Tab(text: Strings.standings),
        const Tab(text: Strings.topPlayers),
        //Top stats
        //top teams
      ];

  List<Widget> _views() => [
        FixturesPage(
          key: ValueKey('Matches_$_selectedSeason'),
          leagueId: widget.league.league.id,
          season: _selectedSeason,
          groupFixtures: false,
        ),
        StandingsPage(
          key: ValueKey('Standings_$_selectedSeason'),
          leagueId: widget.league.league.id,
          season: _selectedSeason,
        ),
        TopPlayersPageView(
          key: ValueKey('TopPlayers_$_selectedSeason'),
          leagueId: widget.league.league.id,
          season: _selectedSeason,
        )
      ];
}