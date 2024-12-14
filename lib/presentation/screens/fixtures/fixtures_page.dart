import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../_utils/utils.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/pin_leagues/blocs/pinned_leagues_cubit/pinned_leagues_bloc.dart';
import '../../../features/pin_leagues/models/pinned_league.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixtures_cubit/fixtures_cubit.dart';
import '../../../features/football_api/models/fixture/fixture_details.dart';
import '../../../features/football_api/repositories/fixtures_repository.dart';
import '../../widgets/banner_ad_injector.dart';
import '../../widgets/fixture_card.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/league_fixtures_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/shadowless_card.dart';

class FixturesPage extends StatefulWidget {
  const FixturesPage({
    super.key,
    this.date,
    this.live,
    this.leagueId,
    this.season,
    this.groupFixtures = true,
  });

  final DateTime? date;
  final String? live;
  final int? leagueId;
  final int? season;
  final bool groupFixtures;

  @override
  State<FixturesPage> createState() => _FixturesPageState();
}

class _FixturesPageState extends State<FixturesPage> with AutomaticKeepAliveClientMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PinnedLeaguesBloc, PinnedLeaguesState>(
      builder: (context, pinnedLeaguesState) {
        return BlocProvider(
          create: (context) => FixturesCubit(
            context.read<FixturesRepository>(),
          )..getFixtures(
              date: widget.date,
              live: widget.live,
              leagueId: widget.leagueId,
              season: widget.season,
            ),
          child: BlocBuilder<FixturesCubit, ApiState>(
            builder: (context, fixturesState) {
              if (fixturesState is LoadingState) {
                return const LoadingWidget();
              }
              if (fixturesState is ErrorState) {
                return InfoWidget(
                  text: fixturesState.message,
                  icon: soccer24Icons.error,
                  color: context.colorScheme.error,
                  buttonText: Strings.retry,
                  padding: EdgeInsets.all(DefaultValues.padding),
                  onButtonTaped: () => _requestData(context),
                );
              }
              if (fixturesState is FixturesLoadedState) {
                if (fixturesState.fixtures.isEmpty) {
                  return InfoWidget(
                    text: Strings.apiNoFixtures,
                    icon: soccer24Icons.empty,
                    color: context.colorScheme.secondaryContainer,
                    padding: EdgeInsets.all(DefaultValues.padding),
                  );
                }

                if (!widget.groupFixtures) {
                  return ScrollablePositionedList.builder(
                    key: UniqueKey(),
                    itemScrollController: itemScrollController,
                    scrollOffsetController: scrollOffsetController,
                    itemPositionsListener: itemPositionsListener,
                    scrollOffsetListener: scrollOffsetListener,
                    initialScrollIndex: fixturesState.firstUpcomingIndex,
                    itemCount: fixturesState.fixtures.length,
                    padding: EdgeInsets.only(bottom: DefaultValues.spacing * 4),
                    itemBuilder: (context, index) {
                      return BannerAdInjector(
                        condition: index % DefaultValues.bannerAdInterval == 0,
                        mrec: index % (DefaultValues.bannerAdInterval * 2) == 0,
                        child: FixtureCard(
                          key: GlobalObjectKey(index),
                          fixture: fixturesState.fixtures[index],
                          showDate: true,
                        ),
                      );
                    },
                  );
                }

                final groupedFixtures = Utils.groupFixturesByLeague(fixturesState.fixtures);

                final pinnedLeaguesFixtures = _getPinnedLeagues(
                  groupedFixtures,
                  pinnedLeaguesState.pinnedLeagues,
                );

                return ListView.builder(
                  key: UniqueKey(),
                  itemCount: groupedFixtures.length + pinnedLeaguesFixtures.length + 2,
                  padding: EdgeInsets.only(bottom: DefaultValues.spacing * 4),
                  itemBuilder: (context, index) {
                    //Pinned leagues title
                    if (index == 0) {
                      final Widget pinnedCard = ShadowlessCard(
                        color: context.colorScheme.primaryContainer,
                        opacity: 0.6,
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(DefaultValues.padding / 2),
                          child: Text(
                            Strings.pinnedLeagues,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                      if (pinnedLeaguesFixtures.isEmpty) {
                        return Column(
                          children: [
                            pinnedCard,
                            InfoWidget(
                              iconSize: 40.r,
                              text: widget.live == null
                                  ? Strings.pinnedLeaguesNoEvents
                                  : Strings.pinnedLeaguesNoLiveEvents,
                              icon: soccer24Icons.empty,
                              color: context.colorScheme.secondaryContainer,
                              padding: EdgeInsets.all(DefaultValues.padding),
                            ),
                          ],
                        );
                      }
                      return pinnedCard;
                    }

                    //Other leagues title
                    if (index == pinnedLeaguesFixtures.length + 1) {
                      return ShadowlessCard(
                        color: context.colorScheme.primaryContainer,
                        opacity: 0.6,
                        child: Padding(
                          padding: EdgeInsets.all(DefaultValues.padding / 2),
                          child: Text(
                            Strings.otherLeagues,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    List<FixtureDetails> leagueFixtures;
                    //Pinned leagues
                    if (index <= pinnedLeaguesFixtures.length) {
                      leagueFixtures = pinnedLeaguesFixtures[index - 1];
                      return BannerAdInjector(
                        condition: (index - 1) % DefaultValues.bannerAdInterval == 0,
                        child: LeagueFixturesCard(fixtures: leagueFixtures),
                      );
                    }

                    leagueFixtures = groupedFixtures[index - pinnedLeaguesFixtures.length - 2];
                    //Other leagues
                    return BannerAdInjector(
                      condition: (index - pinnedLeaguesFixtures.length - 2) %
                              DefaultValues.bannerAdInterval ==
                          0,
                      mrec: (index - pinnedLeaguesFixtures.length - 2) %
                              (DefaultValues.bannerAdInterval * 2) ==
                          0,
                      child: LeagueFixturesCard(fixtures: leagueFixtures),
                    );
                  },
                );
              }
              return InfoWidget(
                text: Strings.somethingWentWrong,
                icon: soccer24Icons.error,
                color: context.colorScheme.error,
                buttonText: Strings.retry,
                padding: EdgeInsets.all(DefaultValues.padding),
                onButtonTaped: () => _requestData(context),
              );
            },
          ),
        );
      },
    );
  }

  void _requestData(BuildContext context) {
    context.read<FixturesCubit>().getFixtures(
          date: widget.date,
          live: widget.live,
          leagueId: widget.leagueId,
          season: widget.season,
        );
  }

  List<List<FixtureDetails>> _getPinnedLeagues(
    List<List<FixtureDetails>> groupedFixtures,
    List<PinnedLeague> favoriteLeagues,
  ) {
    final pinnedLeaguesFixtures = [...groupedFixtures].where((e) {
      if (favoriteLeagues.contains(PinnedLeague(id: e[0].league.id, name: e[0].league.name))) {
        groupedFixtures.remove(e);
        return true;
      }

      return false;
    }).toList();
    return pinnedLeaguesFixtures;
  }
}
