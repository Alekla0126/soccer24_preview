import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/fixture_cubit/fixture_cubit.dart';
import '../../../features/football_api/repositories/fixtures_repository.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import 'fixture_screen.dart';

class FixtureLoadingScreen extends StatelessWidget {
  const FixtureLoadingScreen({
    super.key,
    required this.fixtureId,
  });

  final int fixtureId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FixtureCubit(
        context.read<FixturesRepository>(),
      )..getFixtureById(fixtureId),
      child: BlocBuilder<FixtureCubit, ApiState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Scaffold(body: LoadingWidget());
          }
          if (state is ErrorState) {
            return Scaffold(
              body: InfoWidget(
                text: state.message,
                icon: soccer24Icons.error,
                color: context.colorScheme.error,
                padding: EdgeInsets.all(DefaultValues.padding),
                buttonText: Strings.retry,
                onButtonTaped: () {
                  context.read<FixtureCubit>().getFixtureById(fixtureId);
                },
              ),
            );
          }
          if (state is FixtureLoadedState) {
            return FixtureScreen(fixture: state.fixture);
          }
          return Scaffold(
            body: InfoWidget(
              text: Strings.somethingWentWrong,
              icon: soccer24Icons.error,
              color: context.colorScheme.error,
              padding: EdgeInsets.all(DefaultValues.padding),
              buttonText: Strings.retry,
              onButtonTaped: () {
                context.read<FixtureCubit>().getFixtureById(fixtureId);
              },
            ),
          );
        },
      ),
    );
  }
}
