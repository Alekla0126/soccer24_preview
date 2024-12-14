
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../_utils/utils.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/ads/ads_manager.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixture_events_cubit/fixture_events_cubit.dart';
import '../../../features/football_api/blocs/fixture_lineups_cubit/fixture_lineups_cubit.dart';
import '../../../features/football_api/blocs/fixture_predictions_cubit/fixture_predictions_cubit.dart';
import '../../../features/football_api/blocs/fixture_statistics_cubit/fixture_statistics_cubit.dart';
import '../../../features/football_api/blocs/h2h_cubit/h2h_cubit.dart';
import '../../../features/football_api/blocs/leagues_cubit/leagues_cubit.dart';
import '../../../features/football_api/blocs/leagues_cubit/leagues_state.dart';
import '../../../features/football_api/blocs/odds_cubit/odds_cubit.dart';
import '../../../features/football_api/models/fixture/fixture_details.dart';
import '../../../features/football_api/models/leagues/fixtures.dart';
import '../../../features/football_api/models/leagues/league_model.dart';
import '../../../features/football_api/models/leagues/season.dart';
import '../../../features/football_api/repositories/fixtures_repository.dart';
import '../../widgets/app_sliver_app_bar_delegate.dart';
import '../../widgets/fixture_details_header.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/simplified_fixture_widget.dart';
import '../../widgets/tips_count_badge.dart';
import 'events_page.dart';
import 'head_2_head_page.dart';
import 'lineups_page.dart';
import 'odds_page.dart';
import 'predictions_page.dart';
import 'standings_page.dart';
import 'statistics_page.dart';

class FixtureScreen extends StatefulWidget {
  const FixtureScreen({
    super.key,
    required this.fixture,
  });

  final FixtureDetails fixture;

  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {
  late final ScrollController _scrollController;
  bool _showTitle = false;
  late bool _showOdds;
  late bool _showEvents;
  late bool _showLineups;
  late bool _showStandings;
  late bool _showPredictions;
  late bool _showStats;
  late bool _getPlayersStats;

  late final Widget tipCountBadge;

  @override
  void initState() {
    super.initState();
    tipCountBadge = TipsCountBadge(fixtureId: widget.fixture.fixture.id);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >= 100) {
          setState(() {
            _showTitle = true;
          });
        } else {
          setState(() {
            _showTitle = false;
          });
        }
      });
    _setDefaultValues();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaguesCubit, ApiState>(
      builder: (context, leaguesState) {
        if (leaguesState is LoadingState) {
          return const LoadingWidget();
        }
        if (leaguesState is LeaguesLoadedState) {
          final LeagueModel league;
          try {
            league = leaguesState.leagues
                .where((league) => league.league.id == widget.fixture.league.id)
                .first;
            _setValues(league);
          } catch (_) {
            _setDefaultValues();
          }
        }
        return DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: AnimatedOpacity(
                opacity: _showTitle ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: SimplifiedFixtureWidget(
                  homeTeamName: widget.fixture.teams.home.name,
                  awayTeamName: widget.fixture.teams.away.name,
                ),
              ),
              actions: [
                tipCountBadge,
                Gap(DefaultValues.spacing),
              ],
            ),
            bottomNavigationBar: AdsManager.instance.bannerAd(),
            body: NestedScrollView(
              controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                return [
                  SliverPersistentHeader(
                    delegate: SliverAppBarDelegate(
                      tabBar: PreferredSize(
                        preferredSize: Size.fromHeight(140.h),
                        child: FixtureDetailsHeader(fixture: widget.fixture),
                      ),
                      backgroundColor: context.colorScheme.surface,
                    ),
                    pinned: false,
                  ),
                  SliverPersistentHeader(
                    delegate: SliverAppBarDelegate(
                      tabBar: PreferredSize(
                        preferredSize: _tabBar.preferredSize,
                        child: _tabBar,
                      ),
                      backgroundColor: context.colorScheme.surface,
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => FixtureLineupsCubit(context.read<FixturesRepository>())
                      ..getFixtureLineups(
                        fixtureId: widget.fixture.fixture.id,
                        getPlayersStats: _getPlayersStats,
                      ),
                  ),
                  BlocProvider(
                    create: (context) => FixtureEventsCubit(context.read<FixturesRepository>())
                      ..getFixtureEvents(fixtureId: widget.fixture.fixture.id),
                  ),
                  BlocProvider(
                    create: (context) => FixturePredictionsCubit(context.read<FixturesRepository>())
                      ..getFixturePredictions(fixtureId: widget.fixture.fixture.id),
                  ),
                  BlocProvider(
                    create: (context) => FixtureStatisticsCubit(context.read<FixturesRepository>())
                      ..getFixtureStatistics(fixtureId: widget.fixture.fixture.id),
                  ),
                  BlocProvider(
                    create: (context) => H2HCubit(context.read<FixturesRepository>())
                      ..getHead2Head(
                        firstTeamId: widget.fixture.teams.home.id,
                        secondTeamId: widget.fixture.teams.away.id,
                      ),
                  ),
                  BlocProvider(
                    create: (context) => OddsCubit(context.read<FixturesRepository>())
                      ..getPreMatchOddsFromApi(widget.fixture.fixture.id),
                  ),
                ],
                child: TabBarView(
                  children: _views,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _setValues(LeagueModel league) {
    final Season season;
    try {
      season = league.seasons.singleWhere((s) => s.year == widget.fixture.league.season);
    } catch (_) {
      return;
    }
    final timestampNow = DateTime.now().millisecondsSinceEpoch / 1000;
    final fixtureTimestamp = widget.fixture.fixture.timestamp;
    final coverage = season.coverage;
    final Fixtures fixture = coverage.fixtures;

    _showOdds = coverage.odds;
    _showEvents = fixture.events && fixtureTimestamp <= timestampNow;
    _showLineups = fixture.lineups && fixtureTimestamp <= timestampNow + 15 * 60;
    _showStats = fixture.statisticsFixtures && fixtureTimestamp < timestampNow;
    _showStandings = coverage.standings;
    _showPredictions = coverage.predictions;
    _getPlayersStats = fixture.statisticsPlayers && fixtureTimestamp <= timestampNow;
  }

  void _setDefaultValues() {
    final timestampNow = DateTime.now().millisecondsSinceEpoch / 1000;
    final fixtureTimestamp = widget.fixture.fixture.timestamp;
    _showOdds = true;
    _showEvents = fixtureTimestamp < timestampNow;
    _showLineups = fixtureTimestamp < timestampNow - 15 * 60;
    _getPlayersStats = _showEvents;
    _showStats = _showEvents;
    _showPredictions = true;
    _showStandings = true;
  }

  TabBar get _tabBar {
    return TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: _tabs,
    );
  }

  List<Widget> get _views => [
        if (_showOdds)
          OddsPage(
            fixture: widget.fixture,
          ),
        if (_showPredictions)
          PredictionPage(
            fixtureId: widget.fixture.fixture.id,
            homeTeamId: widget.fixture.teams.home.id,
            homeGoals: widget.fixture.goals.home,
            awayGoals: widget.fixture.goals.away,
            isMatchFinished: Utils.isMatchFinished(widget.fixture.fixture.status.short),
          ),
        if (_showEvents)
          EventsPage(
            fixtureId: widget.fixture.fixture.id,
            homeTeamId: widget.fixture.teams.home.id,
          ),
        if (_showLineups)
          LineupsPage(
            fixtureId: widget.fixture.fixture.id,
            timestamp: widget.fixture.fixture.timestamp,
          ),
        if (_showStandings)
          StandingsPage(
            season: widget.fixture.league.season!,
            leagueId: widget.fixture.league.id,
          ),
        if (_showStats)
          StatisticsPage(
            fixtureId: widget.fixture.fixture.id,
          ),
        Head2HeadPage(
          firstTeamId: widget.fixture.teams.home.id,
          secondTeamId: widget.fixture.teams.away.id,
        ),
      ];

  List<Widget> get _tabs {
    return [
      if (_showOdds) const Tab(text: Strings.odds),
      if (_showPredictions) const Tab(text: Strings.predictions),
      if (_showEvents) const Tab(text: Strings.events),
      if (_showLineups) const Tab(text: Strings.lineups),
      if (_showStandings) const Tab(text: Strings.standings),
      if (_showStats) const Tab(text: Strings.statistics),
      const Tab(text: Strings.h2h),
    ];
  }
}

