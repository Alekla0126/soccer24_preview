import '../../features/pin_leagues/blocs/pinned_league_cubit/pinned_league_cubit.dart';
import '../../features/pin_leagues/repositories/pin_leagues_repository.dart';
import '../../features/football_api/models/leagues/league_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/bet_smart_icons.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../_utils/utils.dart';
import 'package:gap/gap.dart';
import 'custom_image.dart';


class LeagueWidget extends StatelessWidget {
  const LeagueWidget({super.key, required this.league, required this.onTap});

  final LeagueModel league;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 25.h,
            width: 25.h,
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
              imageUrl: Utils.leagueLogo(league.league.id),
              placeholder: Assets.leagueLogoPlaceholder,
            ),
          ),
          Gap(DefaultValues.spacing / 2),
          Expanded(
            child: Text(league.league.name),
          ),
          Gap(DefaultValues.spacing / 2),
          BlocProvider(
            create: (context) => PinnedLeagueCubit(
              context.read<PinLeaguesRepository>(),
            )..isPinned(league.league.id),
            child: BlocBuilder<PinnedLeagueCubit, bool>(
              builder: (context, isPinned) {
                return GestureDetector(
                  onTap: () {
                    final favLeague  =league.league.toPinned();
                    context.read<PinnedLeagueCubit>().switchPinned(favLeague);
                  },
                  child: Icon(isPinned ? soccer24Icons.pinned : soccer24Icons.unpinned),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}