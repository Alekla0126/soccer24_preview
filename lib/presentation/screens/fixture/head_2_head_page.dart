import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/h2h_cubit/h2h_cubit.dart';
import '../../../features/football_api/blocs/h2h_cubit/h2h_state.dart';
import '../../widgets/h2h_fixture_card.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';

class Head2HeadPage extends StatelessWidget {
  const Head2HeadPage({super.key, required this.firstTeamId, required this.secondTeamId});

  final int firstTeamId;
  final int secondTeamId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<H2HCubit, ApiState>(
      builder: (context, h2hState) {
        if (h2hState is LoadingState) {
          return const LoadingWidget();
        }
        if (h2hState is ErrorState) {
          return InfoWidget(
            text: h2hState.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () => context.read<H2HCubit>().getHead2Head(
                  firstTeamId: firstTeamId,
                  secondTeamId: secondTeamId,
                ),
          );
        }
        if (h2hState is H2HLoadedState) {
          final fixtures = h2hState.fixtures;

          if (fixtures.isEmpty) {
            return InfoWidget(
              text: Strings.apiNoH2H,
              icon: soccer24Icons.empty,
              color: context.colorScheme.secondaryContainer,
              padding: EdgeInsets.all(DefaultValues.padding),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: List<Widget>.generate(
                fixtures.length,
                (index) => H2HFixtureCard(fixture: fixtures[index]),
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
            context.read<H2HCubit>().getHead2Head(
                  firstTeamId: firstTeamId,
                  secondTeamId: secondTeamId,
                );
          },
        );
      },
    );
  }
}
