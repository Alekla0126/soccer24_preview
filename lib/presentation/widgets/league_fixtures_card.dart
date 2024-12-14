import '../../features/pin_leagues/blocs/pinned_league_cubit/pinned_league_cubit.dart';
import '../../features/pin_leagues/repositories/pin_leagues_repository.dart';
import '../../features/football_api/models/fixture/fixture_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'shadowless_card.dart';
import 'custom_image.dart';
import 'fixture_card.dart';


class LeagueFixturesCard extends StatelessWidget {
  const LeagueFixturesCard({super.key, required this.fixtures});

  final List<FixtureDetails> fixtures;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinnedLeagueCubit(
        context.read<PinLeaguesRepository>(),
      )..isPinned(fixtures[0].league.id),
      child: BlocBuilder<PinnedLeagueCubit, bool>(
        builder: (context, state) {
          return ShadowlessCard(
            child: Theme(
              data: context.theme.copyWith(
                splashColor: AppColors.transparent,
                hoverColor: AppColors.transparent,
                highlightColor: AppColors.transparent,
                dividerColor: AppColors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: DefaultValues.padding / 2),
                leading: GestureDetector(
                  onTap: () {
                    final league = fixtures[0].league.toPinned();

                    context.read<PinnedLeagueCubit>().switchPinned(league);
                  },
                  child: Icon(state ? soccer24Icons.pinned : soccer24Icons.unpinned),
                ),
                title: Row(
                  children: [
                    Container(
                      height: 20.h,
                      width: 20.h,
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
                        imageUrl: Utils.leagueLogo(fixtures[0].league.id),
                        placeholder: Assets.leagueLogoPlaceholder,
                      ),
                    ),
                    Gap(DefaultValues.spacing / 2),
                    Expanded(
                      child: Text(
                        fixtures[0].league.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(DefaultValues.spacing / 2),
                    Container(
                      height: 20.h,
                      width: 20.h,
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
                        imageUrl: fixtures[0].league.flag,
                        placeholder: Assets.countryLogoPlaceholder,
                      ),
                    ),
                  ],
                ),
                children: fixtures
                    .map(
                      (fixture) => FixtureCard(
                        key: ValueKey('${fixture.fixture.id}'),
                        fixture: fixture,
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          );
        },
      ),
    );
  }
}