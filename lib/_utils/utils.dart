import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../_package_info/app_info.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/strings.dart';
import '../extensions/enums.dart';
import '../extensions/extensions.dart';
import '../features/pin_leagues/models/pinned_league.dart';
import '../features/football_api/models/fixture/fixture_details.dart';
import '../features/football_api/models/leagues/league_model.dart';
import '../features/football_api/models/leagues/season.dart';

class Utils {
  Utils._();

  ////////////////////////////////////////////
  static String playerImage(int? playerId) {
    if (playerId == null) return '';
    return 'https://media.api-sports.io/football/players/$playerId.png';
  }

  static String coachImage(int? coachId) {
    if (coachId == null) return '';
    return 'https://media.api-sports.io/football/coachs/$coachId.png';
  }

  static String teamLogo(int? teamId) {
    if (teamId == null) return '';
    return 'https://media.api-sports.io/football/teams/$teamId.png';
  }

  static String leagueLogo(int? leagueId) {
    if (leagueId == null) return '';
    return 'https://media.api-sports.io/football/leagues/$leagueId.png';
  }

  static String countryFlag(int? countryId) {
    if (countryId == null) return '';
    return 'https://media.api-sports.io/flags/$countryId.svg';
  }

  ////////////////////////////////////////////

  static bool isMatchFinished(FixtureStatusShort status) {
    switch (status) {
      case FixtureStatusShort.ft:
      case FixtureStatusShort.aet:
      case FixtureStatusShort.pen:
        return true;
      default:
        return false;
    }
  }

  static bool isMatchCancelled(FixtureStatusShort status) {
    switch (status) {
      case FixtureStatusShort.susp:
      case FixtureStatusShort.pst:
      case FixtureStatusShort.canc:
      case FixtureStatusShort.abd:
        return true;
      default:
        return false;
    }
  }

  static bool canSubmitTip(FixtureStatusShort status, int timestamp) {
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 > timestamp) return false;
    switch (status) {
      case FixtureStatusShort.tbd:
      case FixtureStatusShort.ns:
        return true;
      default:
        return false;
    }
  }

  ////////////////////////////////////////////
  static String formatDateTime(DateTime date, [String format = 'MMM dd, yyyy']) {
    return DateFormat(format).format(date);
  }

  static String timeFromApiTimestamp(int timestamp) {
    return DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  static String formatSeason(Season season) {
    String s = '${season.year}';
    final int duration = season.end.difference(season.start).inDays;
    final bool sameYear = season.start.year == season.end.year;
    if (sameYear && duration < 45) return s;
    s += '/${season.year + 1}';
    return s;
  }

  ////////////////////////////////////////////

  static List<List<FixtureDetails>> groupFixturesByLeague(List<FixtureDetails> fixtures) {
    final Map<int, List<FixtureDetails>> groupedFixturesMap = {};

    for (final FixtureDetails fix in fixtures) {
      groupedFixturesMap.putIfAbsent(fix.league.id, () => []).add(fix);
    }

    return groupedFixturesMap.values.toList();
  }

  static List<List<LeagueModel>> groupLeaguesByCountry(List<LeagueModel> leagues) {
    final Map<String, List<LeagueModel>> groupedLeaguesMap = {};

    for (final LeagueModel league in leagues) {
      groupedLeaguesMap.putIfAbsent(league.country.name, () => []).add(league);
    }

    return groupedLeaguesMap.values.toList();
  }

  static List<LeagueModel> searchLeagues({
    required List<LeagueModel> leagues,
    required String query,
  }) {
    return leagues.where((league) {
      return league.league.name.toLowerCase().contains(query.toLowerCase()) ||
          league.country.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<LeagueModel> getPinnedLeagues({
    required List<LeagueModel> leagues,
    required List<PinnedLeague> pinnedLeague,
  }) {
    return leagues.where((league) => pinnedLeague.contains(league.league.toPinned())).toList();
  }

  static String buildUrlPath(String pathName, Map<String, dynamic> params) {
    String path = '';
    params.forEach((key, value) {
      path += value != null ? '&$key=$value' : '';
    });

    path = '$pathName${path.isNotEmpty ? '?${path.substring(1)}' : ''}';

    return path;
  }

  static String abbreviateName(String? name) {
    if (name == null) return '';

    final List<String> nameParts = name.split(' ');

    String abbreviation = '';

    for (int i = 0; i < nameParts.length; i++) {
      if (i == nameParts.length - 2) {
        if (nameParts[i].length > 3) {
          abbreviation += '${nameParts[i][0]}. ';
        } else {
          abbreviation += '${nameParts[i]} ';
        }
      } else if (i < nameParts.length - 1) {
        abbreviation += '${nameParts[i][0]}. ';
      } else {
        abbreviation += nameParts[i];
      }
    }

    return abbreviation.trim();
  }

  static String hiveBoxName(String s) => s.replaceAll(RegExp(r'[^\w\s]+'), '_');

  ////////////////////////////////////////////
  static showToast({
    required String msg,
    Color? textColor,
    Color? backgroundColor,
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.r,
    );
  }

  static Future showRateDialog(BuildContext context) async {
    final RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 3,
      remindDays: 3,
      remindLaunches: 5,
      googlePlayIdentifier: AppInfo.packageName,
      appStoreIdentifier: AppInfo.packageName,
    );

    final bool ignoreNativeDialog = kDebugMode ? Platform.isAndroid : false;
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog && context.mounted) {
        rateMyApp.showRateDialog(
          context,
          title: Strings.rateAppTitle.replaceAll('##', AppInfo.name),
          message: Strings.rateAppMessage.replaceAll('##', AppInfo.name),
          rateButton: Strings.rate,
          noButton: Strings.noThanks,
          laterButton: Strings.later,
          listener: (button) {
            switch (button) {
              case RateMyAppDialogButton.rate:
                debugPrint('Clicked on "Rate".');
                FirebaseAnalytics.instance.logEvent(name: 'app_rate');
                break;
              case RateMyAppDialogButton.later:
                debugPrint('Clicked on "Later".');
                FirebaseAnalytics.instance.logEvent(name: 'app_rate_postponed');
                break;
              case RateMyAppDialogButton.no:
                debugPrint('Clicked on "No".');
                FirebaseAnalytics.instance.logEvent(name: 'app_rate_denied');
                break;
            }

            return true;
          },
          ignoreNativeDialog: ignoreNativeDialog,
          dialogStyle: DialogStyle(
            titleStyle: context.textTheme.titleLarge,
            messageStyle: context.textTheme.bodyMedium,
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
          ),
          // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );
      }
    });
  }

  ////////////////////////////////////////////
  static Future openLink(String url, {LaunchMode? mode}) async {
    if (!await launchUrl(Uri.parse(url), mode: mode ?? LaunchMode.inAppBrowserView)) {
      debugPrint('can\'t launch url');
    }
  }

  static Future rateApp() async {
    String appUrl = '';

    if (Platform.isAndroid) {
      appUrl += Constants.playStoreUrl;
    }

    await openLink(appUrl, mode: LaunchMode.externalApplication);
  }

  static Future shareApp() async {
    String shareMessage;

    if (Platform.isAndroid) {
      shareMessage = Constants.playStoreUrl;
    } else if (Platform.isIOS) {
      shareMessage = Constants.appStoreUrl;
    } else {
      return;
    }
    await Share.share(shareMessage, subject: AppInfo.name);
  }

  static Future sendEmail({
    required MessageReason messageReason,
    required String senderEmail,
    required String subject,
    required String body,
  }) async {
    final String fullSubject = '${messageReason.asString}: $subject';
    final String fullBody =
        '$body\n\nEmail: $senderEmail\nName: ${FirebaseAuth.instance.currentUser!.displayName ?? ''}';

    final String emailUrl = 'mailto:${AppInfo.email}?subject=$fullSubject&body=$fullBody';

    if (!await launchUrl(Uri.parse(emailUrl))) {
      showToast(
        msg: Strings.errorSendingEmail,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.redColor,
        textColor: AppColors.whiteColor,
      );
    }
  }
}
