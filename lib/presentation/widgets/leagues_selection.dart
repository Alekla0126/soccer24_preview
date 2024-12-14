import '../../features/football_api/blocs/leagues_cubit/leagues_cubit.dart';
import '../../features/football_api/blocs/leagues_cubit/leagues_state.dart';
import '../../features/football_api/models/leagues/league_model.dart';
import '../../features/football_api/models/fixture/league.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/football_api/blocs/api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'outlined_text_form_field.dart';
import '../../constants/strings.dart';
import '../../constants/assets.dart';
import '../../_utils/utils.dart';
import 'shadowless_card.dart';
import 'loading_widget.dart';
import 'league_widget.dart';
import 'custom_image.dart';
import 'info_widget.dart';


class LeaguesSelection extends StatefulWidget {
  const LeaguesSelection({super.key, required this.onLeagueSelected});

  final Function(League league) onLeagueSelected;

  @override
  State<LeaguesSelection> createState() => _LeaguesSelectionState();
}

class _LeaguesSelectionState extends State<LeaguesSelection> {
  final TextEditingController _controller = TextEditingController(text: '');
  List<LeagueModel>? leagues;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .7.sh,
      child: BlocConsumer<LeaguesCubit, ApiState>(
        listener: (context, leaguesState) {
          if (leaguesState is LeaguesLoadedState) {}
        },
        builder: (context, leaguesState) {
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
              onButtonTaped: () {
                context.read<LeaguesCubit>().getLeagues(current: true);
              },
            );
          }
          if (leaguesState is LeaguesLoadedState) {
            leagues ??= leaguesState.leagues;

            final List<List<LeagueModel>> groupedLeagues = Utils.groupLeaguesByCountry(leagues!);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(DefaultValues.padding / 2),
                  child: OutlinedTextFormField(
                    controller: _controller,
                    hintText: Strings.searchLC,
                    onChanged: (value) {
                      setState(() {
                        leagues = leaguesState.leagues.where((element) {
                          return element.league.name.toLowerCase().contains(value.toLowerCase()) ||
                              element.country.name.toLowerCase().contains(value.toLowerCase());
                        }).toList();
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
                      itemCount: groupedLeagues.length,
                      itemBuilder: (_, listIndex) {
                        return ShadowlessCard(
                          child: Theme(
                            data: context.theme.copyWith(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              leading: Container(
                                height: 30.h,
                                width: 30.h,
                                clipBehavior: Clip.hardEdge,
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: context.colorScheme.primary,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                    ),
                                  ),
                                ),
                                child: CustomNetworkImage(
                                  imageUrl: groupedLeagues[listIndex][0].country.flag,
                                  placeholder: Assets.countryLogoPlaceholder,
                                ),
                              ),
                              title: Text(groupedLeagues[listIndex][0].country.name),
                              children: List<Widget>.generate(
                                groupedLeagues[listIndex].length,
                                (index) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    DefaultValues.padding * 2,
                                    DefaultValues.padding / 4,
                                    0,
                                    DefaultValues.padding / 4,
                                  ),
                                  child: LeagueWidget(
                                    league: groupedLeagues[listIndex][index],
                                    onTap: () {
                                      widget.onLeagueSelected(
                                        groupedLeagues[listIndex][index].league,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ),
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
            onButtonTaped: () {
              context.read<LeaguesCubit>().getLeagues(current: true);
            },
          );
        },
      ),
    );
  }
}