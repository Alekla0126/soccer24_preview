import '../../features/football_api/models/fixture/fixture_details.dart';
import '../../features/football_api/models/odds/bet_value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/football_api/models/odds/bet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/tips/models/tip_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import 'tip_processing_widget.dart';
import '../../_utils/utils.dart';
import 'bet_value_widget.dart';
import 'shadowless_card.dart';


class OddsWidget extends StatelessWidget {
  const OddsWidget({
    super.key,
    required this.bet,
    required this.fixture,
  });

  final Bet bet;
  final FixtureDetails fixture;

  @override
  Widget build(BuildContext context) {
    return ShadowlessCard(
      child: Theme(
        data: context.theme.copyWith(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(DefaultValues.padding / 2),
          title: Text(bet.name),
          children: [
            Center(
              child: Wrap(
                spacing: DefaultValues.spacing / 2,
                runSpacing: DefaultValues.spacing / 2,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: bet.values.map((betValue) {
                  return GestureDetector(
                    onTap: () => _saveTip(context, betValue),
                    child: SizedBox(
                      width: bet.values.length == 3
                          ? (1.sw - DefaultValues.spacing * 3) / 3
                          : (1.sw - DefaultValues.spacing * 3) / 2,
                      child: BetValueWidget(betValue: betValue),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTip(BuildContext context, BetValue betValue) {
    if (!Utils.canSubmitTip(fixture.fixture.status.short, fixture.fixture.timestamp)) {
      Utils.showToast(
        msg: Strings.shareTipRefused,
        backgroundColor: context.colorScheme.errorContainer,
        textColor: context.colorScheme.onErrorContainer,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    final Tip tip = Tip(
      uid: user?.uid ?? '',
      authorName: user?.displayName,
      authorPicture: user?.photoURL,
      fixtureId: fixture.fixture.id,
      fixtureTimestamp: fixture.fixture.timestamp,
      leagueId: fixture.league.id,
      leagueName: fixture.league.name,
      homeTeamId: fixture.teams.home.id,
      homeTeamName: fixture.teams.home.name,
      awayTeamId: fixture.teams.away.id,
      awayTeamName: fixture.teams.away.name,
      betId: bet.id,
      betName: bet.name,
      betValue: betValue,
      shareTime: Timestamp.now(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return TipProcessingWidget(tip: tip);
      },
    );
  }
}