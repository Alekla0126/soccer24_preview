
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../constants/assets.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/top_players_bloc/top_players_bloc.dart';
import '../../../features/football_api/models/players_statistics/top_players/top_player_statistic.dart';
import '../../../features/football_api/repositories/players_repository.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/top_player.dart';

class TopPlayerPage extends StatefulWidget {
  const TopPlayerPage({super.key, required this.event, required this.pageIndex});

  final TopPlayersEvent event;
  final int pageIndex;

  @override
  State<TopPlayerPage> createState() => _TopPlayerPageState();
}

class _TopPlayerPageState extends State<TopPlayerPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      key: ValueKey('${widget.event.runtimeType}'),
      create: (context) => TopPlayersBloc(
        context.read<PlayersRepository>(),
      )..add(widget.event),
      child: BlocBuilder<TopPlayersBloc, ApiState>(
        builder: (context, state) {
          if (state is LoadingState || state is InitialState) {
            return const LoadingWidget();
          }
          if (state is ErrorState) {
            return InfoWidget(
              text: state.message,
              icon: soccer24Icons.error,
              color: context.colorScheme.error,
              padding: EdgeInsets.all(DefaultValues.padding),
              buttonText: Strings.retry,
              onButtonTaped: () => context.read<TopPlayersBloc>().add(widget.event),
            );
          }
          if (state is TopPlayersLoadedState) {
            if (state.topPlayers.isEmpty) {
              return InfoWidget(
                text: Strings.apiNoData,
                icon: soccer24Icons.empty,
                color: context.colorScheme.secondaryContainer,
                padding: EdgeInsets.all(DefaultValues.padding),
              );
            }

            return ListView.builder(
              itemCount: state.topPlayers.length,
              itemBuilder: (context, index) {
                final playerStats = state.topPlayers[index];

                return TopPlayer(
                  teamId: playerStats.statistics[0].team.id,
                  playerInfo: playerStats.player,
                  statsWidget: _stats(playerStats.statistics[0])[widget.pageIndex],
                );
              },
            );
          }

          return InfoWidget(
            text: Strings.somethingWentWrong,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () => context.read<TopPlayersBloc>().add(widget.event),
          );
        },
      ),
    );
  }

  List<Widget> _stats(TopPlayerStatistic statistic) {
    return [
      _statsWidgetRow(
        [
          Assets.goalIconPath,
          Assets.assistIconPath,
        ],
        [
          '${statistic.goals.total}',
          '${statistic.goals.assists}',
        ],
      ),
      _statsWidgetRow(
        [
          Assets.assistIconPath,
          Assets.goalIconPath,
        ],
        [
          '${statistic.goals.assists}',
          '${statistic.goals.total}',
        ],
      ),
      _statsWidgetRow(
        [
          Assets.yellowCardIconPath,
          Assets.yellowRedCardIconPath,
          Assets.redCardIconPath,
        ],
        [
          '${statistic.cards.yellow}',
          '${statistic.cards.yellowred}',
          '${statistic.cards.red}',
        ],
      ),
      _statsWidgetRow(
        [
          Assets.redCardIconPath,
          Assets.yellowRedCardIconPath,
          Assets.yellowCardIconPath,
        ],
        [
          '${statistic.cards.red}',
          '${statistic.cards.yellowred}',
          '${statistic.cards.yellow}',
        ],
      ),
    ];
  }

  Widget _statsWidget(String iconPath, String data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          height: 15.r,
          width: 15.r,
        ),
        Gap(DefaultValues.spacing / 4),
        Text(data),
      ],
    );
  }

  Widget _statsWidgetRow(List<String> icons, List<String> data) {
    final List<Widget> children = [];

    for (int i = 0; i < icons.length; i++) {
      i == icons.length - 1
          ? children.add(_statsWidget(icons[i], data[i]))
          : children.addAll([_statsWidget(icons[i], data[i]), const VerticalDivider()]);
    }

    return SizedBox(
      height: 20.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
