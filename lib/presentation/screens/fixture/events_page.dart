import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixture_events_cubit/fixture_events_cubit.dart';
import '../../../features/football_api/blocs/fixture_events_cubit/fixture_events_state.dart';
import '../../widgets/event_widget.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/shadowless_card.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key, required this.fixtureId, required this.homeTeamId});

  final int fixtureId;
  final int homeTeamId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixtureEventsCubit, ApiState>(
      builder: (context, eventsState) {
        if (eventsState is LoadingState) {
          return const LoadingWidget();
        }
        if (eventsState is ErrorState) {
          return InfoWidget(
            text: eventsState.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () =>
                context.read<FixtureEventsCubit>().getFixtureEvents(fixtureId: fixtureId),
          );
        }
        if (eventsState is FixtureEventsLoadedState) {
          if (eventsState.events.isEmpty) {
            return InfoWidget(
              text: Strings.apiNoEvents,
              icon: soccer24Icons.empty,
              color: context.colorScheme.secondaryContainer,
              padding: EdgeInsets.all(DefaultValues.padding),
            );
          }
          final events = eventsState.events.reversed.toList(growable: false);
          return SingleChildScrollView(
            child: ShadowlessCard(
              child: Column(
                children: List<Widget>.generate(
                  events.length,
                  (index) => EventWidget(
                    event: events[index],
                    isHomeEvent: events[index].team?.id == homeTeamId,
                  ),
                ),
              ),
            ),
          );
        }

        return InfoWidget(
          text: Strings.somethingWentWrong,
          icon: soccer24Icons.error,
          color: context.colorScheme.error,
          padding: EdgeInsets.all(DefaultValues.padding),
          buttonText: Strings.retry,
          onButtonTaped: () {
            context.read<FixtureEventsCubit>().getFixtureEvents(fixtureId: fixtureId);
          },
        );
      },
    );
  }
}
