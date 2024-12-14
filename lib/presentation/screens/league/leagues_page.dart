import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_utils/utils.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/pin_leagues/blocs/pinned_leagues_cubit/pinned_leagues_bloc.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/leagues_cubit/leagues_cubit.dart';
import '../../../features/football_api/blocs/leagues_cubit/leagues_state.dart';
import '../../../features/football_api/models/leagues/league_model.dart';
import '../../widgets/banner_ad_injector.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/leagues_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/outlined_text_form_field.dart';

class LeaguesPage extends StatefulWidget {
  const LeaguesPage({super.key});

  @override
  State<LeaguesPage> createState() => _LeaguesPageState();
}

class _LeaguesPageState extends State<LeaguesPage> {
  final TextEditingController _controller = TextEditingController(text: '');
  List<LeagueModel>? _leagues;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.leagues),
      ),
      body: Builder(builder: (context) {
        final leaguesState = context.read<LeaguesCubit>().state;
        final pinnedLeaguesState = context.read<PinnedLeaguesBloc>().state;
        if (leaguesState is LoadingState) {
          return const LoadingWidget();
        }
        if (leaguesState is ErrorState) {
          return InfoWidget(
            text: leaguesState.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () => context.read<LeaguesCubit>().getLeagues(),
          );
        }

        if (leaguesState is LeaguesLoadedState) {
          _leagues ??= leaguesState.leagues;

          final groupedLeagues = Utils.groupLeaguesByCountry(_leagues!);

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(DefaultValues.padding / 2),
                child: OutlinedTextFormField(
                  controller: _controller,
                  hintText: Strings.searchLC,
                  onChanged: (query) {
                    setState(() {
                      _leagues = Utils.searchLeagues(
                        leagues: leaguesState.leagues,
                        query: query,
                      );
                    });
                  },
                ),
              ),
              if (groupedLeagues.isEmpty)
                InfoWidget(
                  text: Strings.noLeaguesFound,
                  icon: soccer24Icons.empty,
                  color: context.colorScheme.secondaryContainer,
                  padding: EdgeInsets.all(DefaultValues.padding),
                ),
              if (groupedLeagues.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(DefaultValues.padding / 2),
                    itemCount: groupedLeagues.length + 1,
                    itemBuilder: (context, listIndex) {
                      if (listIndex == 0) {
                        final pinned = Utils.getPinnedLeagues(
                          leagues: _leagues!,
                          pinnedLeague: pinnedLeaguesState.pinnedLeagues,
                        );
                        return LeaguesCard(
                          title: Strings.pinnedLeagues,
                          emptyMessage: Strings.pinnedLeaguesEmpty,
                          icon: const Icon(soccer24Icons.pinned),
                          leagues: pinned,
                        );
                      }

                      return BannerAdInjector(
                        condition: (listIndex - 1) % DefaultValues.bannerAdInterval == 0,
                        // mrec: (listIndex - 1) % DefaultValues.bannerAdInterval * 2 == 0,
                        child: LeaguesCard(
                          leagues: groupedLeagues[listIndex - 1],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        }

        return InfoWidget(
          text: Strings.somethingWentWrong,
          icon: soccer24Icons.error,
          color: context.colorScheme.error,
          padding: EdgeInsets.all(DefaultValues.padding),
          buttonText: Strings.retry,
          onButtonTaped: () => context.read<LeaguesCubit>().getLeagues(),
        );
      }),
    );
  }
}
