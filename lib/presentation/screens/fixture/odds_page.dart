import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/blocs/api_state.dart';
import '../../../features/football_api/blocs/odds_cubit/odds_cubit.dart';
import '../../../features/football_api/models/fixture/fixture_details.dart';
import '../../../features/football_api/models/odds/bookmaker_bets.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/odds_widget.dart';

class OddsPage extends StatefulWidget {
  const OddsPage({super.key, required this.fixture});

  final FixtureDetails fixture;

  @override
  State<OddsPage> createState() => _OddsPageState();
}

class _OddsPageState extends State<OddsPage> {
  BookmakerBets? _selectedBookmaker;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OddsCubit, ApiState>(
      listener: (context, state) {
        if (state is OddsLoadedState) {
          try {
            _selectedBookmaker = state.bookmakerBets.firstWhere(
              (bookmaker) => bookmaker.id == DefaultValues.defaultBookmakerId,
            );
          } catch (_) {
            _selectedBookmaker = null;
          }
        }
      },
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingWidget();
        }
        if (state is ErrorState) {
          return InfoWidget(
            text: state.message,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () =>
                context.read<OddsCubit>().getPreMatchOddsFromApi(widget.fixture.fixture.id),
          );
        }
        if (state is OddsLoadedState) {
          if (state.bookmakerBets.isEmpty) {
            return InfoWidget(
              text: Strings.apiNoOdds,
              icon: soccer24Icons.empty,
              color: context.colorScheme.secondaryContainer,
              padding: EdgeInsets.all(DefaultValues.padding),
            );
          }
          final selectedBookmaker = _selectedBookmaker ?? state.bookmakerBets[0];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(DefaultValues.padding / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.selectBookmaker,
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
                        child: DropdownButton<BookmakerBets?>(
                          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
                          dropdownColor: context.colorScheme.secondaryContainer,
                          menuMaxHeight: .5.sh,
                          isExpanded: true,
                          style: context.textTheme.bodyLarge,
                          value: _selectedBookmaker,
                          items: List<DropdownMenuItem<BookmakerBets>>.generate(
                            state.bookmakerBets.length,
                            (index) {
                              return DropdownMenuItem(
                                value: state.bookmakerBets[index],
                                child: Text(state.bookmakerBets[index].name),
                              );
                            },
                          ),
                          onChanged: (s) => setState(() => _selectedBookmaker = s),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedBookmaker.bets.length,
                  itemBuilder: (context, index) {
                    return OddsWidget(
                      bet: selectedBookmaker.bets[index],
                      fixture: widget.fixture,
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
          onButtonTaped: () =>
              context.read<OddsCubit>().getPreMatchOddsFromApi(widget.fixture.fixture.id),
        );
      },
    );
  }
}
